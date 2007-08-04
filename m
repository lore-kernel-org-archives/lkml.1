Return-Path: <linux-kernel-owner+w=401wt.eu-S1765477AbXHDTFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765477AbXHDTFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932495AbXHDTFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:05:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:60214 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760280AbXHDTFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:05:45 -0400
Date: Sat, 4 Aug 2007 21:05:39 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: William Pettersson <william.pettersson@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dtor@insightbb.com
Subject: Re: ALPS touchpad with new Dell not recognised
Message-ID: <20070804190539.GB5110@suse.cz>
References: <46B03A42.3030708@gmail.com> <46B46DFA.7000909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B46DFA.7000909@gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 10:15:54PM +1000, William Pettersson wrote:

> Hi LKML,
> Thanks to Vojtech for some advice, I finally got something happening
> with this.  Turns out I had to add support for a new model in alps.c,
> the attached file does this successfully for my laptop.  It'd be nice to
> have others test it, but I am yet to find anyone else who has this same
> laptop, with the same mouse issues I have.
> 
> With this patch, I now get a functioning touchpad, including side
> scrolling, circle scrolling, corner taps etc.  However, I did have to
> ramp the configuration numbers up significantly from my old Thinkpad
> with its synaptics touchpad.

That is normal. The ALPS's have very much different parameters -
sensitivity, resolution, etc., so that the settings aren't easily
comparable.

> Minspeed is now 0.8 and maxspeed is 10. 
> Also the VertScrollDelta is 10.  I don't know whether these numbers are
> crazy high, or just normal for the Alps though.

I don't remember exactly myself - I'm only interested in the low level
of the protocol - making sure the kernel delivers correctly decoded data
to userspace.

Please send the patch to Dmitry Torokhov, who is nowadays a maintainer
of this driver and the input subsystem. And don't forget to add a
description of the patch and a "Signed-off-by:" line.

I'm quite surprised you needed the value of 0x4f, I'd expect the highest
bit always set in the sync byte of the protocol. Can you send me (and
dmitry) the dump data you gathered using i8042.debug?

Thanks,
	Vojtech

> --- drivers/input/mouse/alps.c.old	2007-07-31 21:42:37.000000000 +1000
> +++ drivers/input/mouse/alps.c	2007-08-04 21:45:43.000000000 +1000
> @@ -53,6 +53,7 @@
>  	{ { 0x20, 0x02, 0x0e },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */
>  	{ { 0x22, 0x02, 0x0a },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
>  	{ { 0x22, 0x02, 0x14 }, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
> +	{ { 0x73, 0x02, 0x50 }, 0x4f, 0x4f, ALPS_FW_BK_1 } /* Dell Vostro 1400 */
>  };

-- 
Vojtech Pavlik
Director SuSE Labs
