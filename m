Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZFWPN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZFWPN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZFWPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:13:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48579 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZFWPNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:13:18 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@ZenIV.linux.org.uk, adilger@sun.com, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
In-reply-to: <20090623143408.GA2147@infradead.org> (message from Christoph
	Hellwig on Tue, 23 Jun 2009 10:34:08 -0400)
Subject: Re: [RFC] O_NOACC: open without any access
References: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org>
Message-Id: <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Jun 2009 17:13:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Christoph Hellwig wrote:
> On Tue, Jun 23, 2009 at 04:12:22PM +0200, Miklos Szeredi wrote:
> > > an issue ioctls + stat / etc on it ut not actually read/write it.
> > 
> > Two differences between open("foo", 3) and open("foo", O_NOACC):
> > 
> >   1) open with "3" requires _read_and_write_ permissions on foo, but
> >      does not allow either read or write.  Not sure what the logic in
> >      that, but that's the way it has always been.
> 
> Which is a quite sensible requirement if we want to do ioctls.

Right, but that makes it useless for things which want to open it
despite having no permission on the file.  For example some programs
do:

	fd = open(".", 0);
        chdir(someplace);
	/* do something */
	fchdir(fd);

or for that matter:

	fd = open("foo", 0);
	fstat(fd, &stat1);
	if (something)
		fchmod(fd, ...);
	close(fd);

Note: neither chmod() nor chdir() (nor host of others) require either
read or write permissions on the file, so we _should_ be able to do
this kind of thing without open() requiring them.

Thanks,
Miklos
