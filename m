Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbZLJHji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbZLJHji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbZLJHje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:39:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38232 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760556AbZLJHjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:39:33 -0500
Date: Thu, 10 Dec 2009 08:39:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, luto@mit.edu,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091210073901.GA1376@ucw.cz>
References: <20091202204828.4fa0c108@lxorguk.ukuu.org.uk> <E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu> <4B1A7159.3070101@mit.edu> <E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu> <20091205202838.3456b6fc@lxorguk.ukuu.org.uk> <E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu> <20091205231304.03a4af61@lxorguk.ukuu.org.uk> <E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu> <20091207122346.6d18a8e1@lxorguk.ukuu.org.uk> <E1NHctp-00032C-A1@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NHctp-00032C-A1@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-07 13:41:09, Miklos Szeredi wrote:
> On Mon, 7 Dec 2009, Alan Cox wrote:
> > The standard udev unload is a true open barrier so has an implicit
> > revoke() caused by the fact you cannot keep a handle to the filename open
> > during the udev sequence (or the old driver would be pinned by a refcount
> > and not unload).
> 
> True, udev unload is an open barrier (modulo races), but O_NODE opens
> simply don't matter in this respect, because they don't have anything
> to do with the driver.
> 
>   ln /dev/foo /dev/shm/my_secret_device_link
>   (foo is removed)
>   open("/dev/shm/my_secret_device_link", O_RDWR)
> 
> How is this different than keeping the device open with O_NODE?

First version needs writable directory on same fs as /dev, which may
not be there in all configs. (Plus note various 'security enhanced'
linuxes that do not allow hardlinks on files you don't own. Maybe
someone uses subterfugue.sf.net to disallow hardlinks.)

Plus, you can see hardlinks on ta-daa 'link count'.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
