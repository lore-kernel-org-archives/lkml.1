Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYKVKfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYKVKfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 05:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYKVKfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 05:35:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40856 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYKVKfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 05:35:37 -0500
Date: Sat, 22 Nov 2008 11:37:17 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: backlight: catch invalid input
Message-ID: <20081122103717.GA8136@elf.ucw.cz>
References: <20081121111414.GA1455@elf.ucw.cz> <20081121155421.152cc555.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121155421.152cc555.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-11-21 15:54:21, Andrew Morton wrote:
> On Fri, 21 Nov 2008 12:14:14 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > 
> > Currently, echo > brightness turns brightness to zero due to
> > insufficient checking. Add a test to catch that.
> > 
> 
> OK.  And what happens if you do
> 
> 	echo wibble > brightness
> 
> ?

That's okay, that is catched by tests already existing in there. size
is the size we decoded, count is how many bytes user wrote. If (size
!= count), we return failure.

But there's an exception for whitespace, and missing check for nothing
at all being written.

> > diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> > index fab0bc8..5c2e23d 100644
> > --- a/drivers/video/backlight/backlight.c
> > +++ b/drivers/video/backlight/backlight.c
> > @@ -86,6 +86,8 @@ static ssize_t backlight_store_power(str
> >  	int power = simple_strtoul(buf, &endp, 0);
> >  	size_t size = endp - buf;
> >  
> > +	if (!size)
> > +		return -EINVAL;
> >  	if (*endp && isspace(*endp))
> >  		size++;
> >  	if (size != count)
> 
> A better fix would be to use strict_strtoul() and check its return
> value.

Aha, here's the hint :-). Ok, will do.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
