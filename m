Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbYHGWGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbYHGWGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYHGWGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:06:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53889 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYHGWGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:06:32 -0400
Date: Fri, 8 Aug 2008 00:07:55 +0200
From: Pavel Machek <pavel@suse.cz>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, krzysztof.h1@poczta.fm,
       adaplas@pol.net, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.27-rc1: softcursor behaviour changed
Message-ID: <20080807220755.GA11460@elf.ucw.cz>
References: <20080805212004.GA1592@elf.ucw.cz> <20080807085733.GA1560@elf.ucw.cz> <489AD9C1.8020405@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489AD9C1.8020405@eu.citrix.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-08-07 12:17:21, Stefano Stabellini wrote:
> Pavel Machek wrote:
> 
> > Hi!
> > 
> >> In 2.6.26, this 
> >>
> >>     echo -e "\33[10;5000]\33[11;50]\33[?18;0;136c\33[?102m"
> >>
> >> produces some variation on cursor. on 2.6.27-rc1, I have no cursor at
> >> all :-(.
> > 
> > The patch that changed it is below... and I must say I liked the old
> > behaviour better. Unlike blinking, high-brightness background is
> > actually useful. Can we get that one reverted?
> 
> 
> The problem is not a matter of taste but a matter of correctness: the
> build_attr function in drivers/char/vt.c stores the blink attribute as
> the forth bit of the background color.
> Then in fbcon we are interpreting the same forth bit of the background
> color as intensity bit.

...which works pretty well. We can't reasonably blink in fbcon, so we
highlight it with bright background, instead. Even old VGA had option
to do that.

> My patch fixes that.

AFAICS high bit is now completely ignored now. That makes it
useless...

For example I can no longer see my cursor.

So, if 2.6.26 behaviour is "incorrect", can you show example where it
matters, and how your patch "helps"?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
