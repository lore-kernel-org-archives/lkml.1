Return-Path: <linux-kernel-owner+w=401wt.eu-S1760989AbXEJKtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989AbXEJKtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbXEJKtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:49:04 -0400
Received: from [80.75.67.54] ([80.75.67.54]:35639 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758671AbXEJKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:49:02 -0400
Subject: Re: [alsa-devel] Mic and Line In Capture AC97 slots issue
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <8d6898730705091415s74685223r4c4409e87ff587c@mail.gmail.com>
References: <8d6898730705091415s74685223r4c4409e87ff587c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 11:48:59 +0100
Message-Id: <1178794139.10518.12.camel@a10072.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 02:45 +0530, Nobin Mathew wrote:
> http://mailman.alsa-project.org/pipermail/alsa-devel/2007-May/000835.html
> http://mailman.alsa-project.org/pipermail/alsa-devel/2007-May/000837.html
> 
> the overrun  issue was because my application was not fast enough.
> 
> I resolved that problem by disabling capture of AC-Link slot4 in my
> ac97 controller.
> So capture happens only in slot3.
> 
> According to ac97 spec Mic comes in Slot6 of AC-Link.
> 
> I am using wolfson wm9713 codec.
> 
> In this LineR and LineL are routed to LeftADC and RightADC.
> 
> And Mic1 (Mic A) is also coonected to LeftADC and RightADC.
> 
> 
> So i am assuming that Mic 1 will come in Slot3 and Slot4.
> 
> But my application is taking only mono data, so XRUN will happen.
> 
> 
> What is the correct configuration for this?
> What should be the configuration if i want to capture both Line IN and Mic?
> means AC-Link settings
> 

At least 2 AC97 slots must be active in order to capture 2 separate
channels (i.e. Mic1 and Line II). Hence, you will need to enable slots 3
& 4 for _stereo_ audio capture.

Mono capture (1 AC97 slot) of Mic1, Line R & L can be accomplished on
the WM9713 by mixing all the required signals into the Mono mixer and
capturing the mixer output with either the left ADC (slot 3) or the
right ADC (slot 4). The easiest way to set this up is to look at the
audio diagram on page 13 of the datasheet and run alsamixer to change
the mixers. alsactl can then be used to store your mixer settings.

Liam

