Return-Path: <linux-kernel-owner+w=401wt.eu-S933487AbXBXKrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbXBXKrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 05:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933495AbXBXKrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 05:47:00 -0500
Received: from styx.suse.cz ([82.119.242.94]:36624 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933491AbXBXKqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 05:46:52 -0500
Date: Sat, 24 Feb 2007 11:46:38 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Milind Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
Message-ID: <20070224104638.GA3609@suse.cz>
References: <3b44d3fb0702222056k1d2a9b57q69a3555a09a9058e@mail.gmail.com> <3b44d3fb0702230014x4ee4a1dewdc624c54b3635e15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b44d3fb0702230014x4ee4a1dewdc624c54b3635e15@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 01:44:41PM +0530, Milind Choudhary wrote:
> Hi all
> 	working towards the cleanup of BIT macro,
> I've added one to <linux/bitops.h> & cleaned some obvious users.
> 
> include/linux/input.h also has a BIT macro
> which does a wrap
> so currently i've done something like
> 
> +#undef BIT
> #define BIT(nr)        (1UL << ((nr) % BITS_PER_LONG))
 
Since the previous definition of

#define BIT(nr)		(1UL << (nr))

gives the same results as the above one for all reasonable usage
scenarios (you don't want to supply nr larger than BITS_PER_LONG),
why not just use the modulo version everywhere?

The only problem I see is that the compiler would not warn where nr IS
too large.

-- 
Vojtech Pavlik
Director SuSE Labs
