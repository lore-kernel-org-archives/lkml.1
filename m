Return-Path: <linux-kernel-owner+w=401wt.eu-S964917AbZLGRje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917AbZLGRje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964902AbZLGRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:39:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45843 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964881AbZLGRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:39:15 -0500
Date: Mon, 7 Dec 2009 17:40:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, luto@mit.edu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091207174049.50537ddf@lxorguk.ukuu.org.uk>
In-Reply-To: <E1NHfEu-0003SM-U0@pomaz-ex.szeredi.hu>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
	<20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
	<E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu>
	<20091205231304.03a4af61@lxorguk.ukuu.org.uk>
	<E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu>
	<20091207122346.6d18a8e1@lxorguk.ukuu.org.uk>
	<E1NHctp-00032C-A1@pomaz-ex.szeredi.hu>
	<E1NHd0J-000345-Kw@pomaz-ex.szeredi.hu>
	<20091207130339.620b904b@lxorguk.ukuu.org.uk>
	<E1NHdJy-00037l-Jb@pomaz-ex.szeredi.hu>
	<20091207131546.2af06647@lxorguk.ukuu.org.uk>
	<E1NHdS9-00039i-B6@pomaz-ex.szeredi.hu>
	<20091207141321.0964461d@lxorguk.ukuu.org.uk>
	<E1NHeXH-0003Lb-3q@pomaz-ex.szeredi.hu>
	<20091207144623.692fbc1e@lxorguk.ukuu.org.uk>
	<E1NHfEu-0003SM-U0@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, yes.  That's true.  But I still don't think revoke() is the
> answer here.  For example even without the possibility of hard links
> there's still a race in udev in the following course of events:
> 
>   open("/dev/foo", O_RDWR)
>   ... open passes permission checks
>   ... driver gets unloaded
>   ... driver intended for other user gets loaded
>   ... open finds new driver

> What we really need is to revoke the *inode*, so that it cannot be
> opened any more.  Doing it with unlink() and revoke() and requiring
> that link() does not work on the filesystem is a poor and racy
> substitute for that.

Can't argue with that and going through the kernel logic I don't see
anything preventing an exploit based on that from working.

Alan
