Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbXFKOcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbXFKOcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXFKOca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:32:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59191 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752109AbXFKOc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:32:28 -0400
Date: Mon, 11 Jun 2007 16:32:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: B.Steinbrink@gmx.de, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: fix oops on cat /dev/snapshot
Message-ID: <20070611143219.GA1759@elf.ucw.cz>
References: <20070611121716.GA1904@elf.ucw.cz> <200706111636.42555.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706111636.42555.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > What /dev/snapshot is simply cat-ed -- without ioctls used in normal
> > operation -- it oopses. This one should fix it.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > --- clean-mm/kernel/power/user.c	2007-06-09 16:18:12.000000000 +0200
> > +++ linux-mm/kernel/power/user.c	2007-06-11 14:06:19.000000000 +0200
> > @@ -99,6 +99,8 @@
> >  	ssize_t res;
> >  
> >  	data = filp->private_data;
> > +	if (!data->ready)
> > +		return -EINVAL;
> 
> I'd like to use -ENODATA here.
> 
> >  	res = snapshot_read_next(&data->handle, count);
> >  	if (res > 0) {
> >  		if (copy_to_user(buf, data_of(data->handle), res))
> > 
> 
> I have a patch for that and I'm going to post it in a while if you don't
> mind.
> 
> I've already posted it once, here: http://lkml.org/lkml/2007/6/10/146

Aha, go ahead, I did not notice that mail.
										Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
