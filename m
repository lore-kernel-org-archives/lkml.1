Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbZLOUr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbZLOUr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932305AbZLOUr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:47:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53270 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbZLOUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:47:56 -0500
Date: Tue, 15 Dec 2009 21:47:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091215204748.GN24406@elf.ucw.cz>
References: <4B203575.6050407@bluewatersys.com>
 <20091210172458.GJ19454@elf.ucw.cz>
 <4B2150B7.3040207@bluewatersys.com>
 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
 <20091211221015.GB24456@elf.ucw.cz>
 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
 <20091214064545.GK5114@elf.ucw.cz>
 <BD79186B4FD85F4B8E60E381CAEE19090200E9E6@mi8nycmail19.Mi8.com>
 <20091215194725.GH24406@elf.ucw.cz>
 <BD79186B4FD85F4B8E60E381CAEE19090200EBE8@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200EBE8@mi8nycmail19.Mi8.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> For completeness you should probably also add:
> >> 
> >> static inline int irq_to_gpio(unsigned irq)
> >> {
> >> 	return -EINVAL;
> >> }
> >
> > I'd say that would be overdoing it.
> 
> I only mentioned that one because it is one of the functions listed in
> Documentation/gpio.txt.  I'm not sure if that means it's "required".  You
> make the call...

Aha, sorry, I misparsed that. There's gpio_to_irq and irq_to_gpio. One
does not seem to be required; as I'm stubbing the other one, I'd
prefer to leave it alone.

> >> Otherwise, looks good to me.  Just test it to make sure it works :-).
> >> 
> >> Since I have no way of compiling or testing this...
> >> 
> >> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >
> > I believe inlining that function would be bad change. Can I still use
> > reviewed-by tag?
> 
> The reason I suggest making it an inline in the header is you might
> eventually want to change both gpio_to_irq and irq_to_gpio into macros
> so that they can be used for static initializers.  For right now both
> are simple return -EINVAL but when gpio irq's are supported you might
> find a need to use one or the other in a platform init...

According to gpio.txt, those are functions, not macros... and I
actually prefer functions, as they are harder to misuse.

> Regardless, yes you can still use my reviesed-by tag.

Thanks.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
