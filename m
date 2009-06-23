Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbZFWOMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbZFWOMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbZFWOMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:12:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55941 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360AbZFWOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:12:35 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@ZenIV.linux.org.uk, adilger@sun.com, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
In-reply-to: <20090623134640.GA13831@infradead.org> (message from Christoph
	Hellwig on Tue, 23 Jun 2009 09:46:40 -0400)
Subject: Re: [RFC] O_NOACC: open without any access
References: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org>
Message-Id: <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Jun 2009 16:12:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Christoph Hellwig wrote:
> we guarantee that f_op is never NULL, so you'll need to assign a
> file operations structure that is empty to it to avoid crashed in
> various places.

Yeah, the patch was just a proof of concept thing (and most places
still check f_op != NULL before dereferncing, so..)

> > It would be logical to reuse the open_flag=3 value, but that has
> > historically been used with different semantics so I'm afraid of
> > touching it.
> 
> I think the historical semantics are exactly that you can open it
> an issue ioctls + stat / etc on it ut not actually read/write it.

Two differences between open("foo", 3) and open("foo", O_NOACC):

  1) open with "3" requires _read_and_write_ permissions on foo, but
     does not allow either read or write.  Not sure what the logic in
     that, but that's the way it has always been.

  2) open with "3" calls driver's ->open() with any side effect that
     may have.  Open with O_NOACC doesn't do that, and hence if we
     want to allow ioctls they need a new interface which gets a
     "struct path" instead of a "struct file".

Thanks,
Miklos
