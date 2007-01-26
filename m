Return-Path: <linux-kernel-owner+w=401wt.eu-S965602AbXAZJg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965602AbXAZJg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 04:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965618AbXAZJg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 04:36:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3674 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965602AbXAZJg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 04:36:57 -0500
Date: Fri, 26 Jan 2007 09:36:43 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-pm@lists.osdl.org
Subject: Re: [patch] suspend/resume debugging: device filter
Message-ID: <20070126093643.GA4627@ucw.cz>
References: <20070125110501.GA25151@elte.hu> <20070126015536.GA14917@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126015536.GA14917@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > it might be better to do this centrally in sysfs, via a per-device 
> > attribute, to individually enable suspend and resume on a per device 
> > basis, but my sysfs-fu is not strong enough for that now ;-)
> 
> Here's a (compile tested only) patch that does this on a per-device
> basis, which is smaller, and should work just as well as your patch.
> 
> It creates a new file in the power/ directory for every device called
> "can_suspend".  Write a '0' to it to prevent that device from being
> suspended.

Maybe we could just introduce debug_flags?

> +static ssize_t can_suspend_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t n)
> +{
> +	if (!n)
> +		return -EINVAL;
> +
> +	switch (buf[0]) {
> +	case 'y':
> +	case 'Y':
> +	case '1':
> +		dev->no_suspend = 0;
> +		break;
> +	case 'n':
> +	case 'N':
> +	case '0':
> +		dev->no_suspend = 1;
> +		break;

default: return -EINVAL ?

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
