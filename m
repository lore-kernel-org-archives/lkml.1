Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYJHGko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYJHGko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYJHGkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:40:36 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44136 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYJHGkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=B4361AoGJPvOkxlgkSWEdXwJ99Hx72t+iW0ZzoMAMNqQTmpkGIxYRuItkW+Y2sDCbi
         +gKUHXjqNryZOthCLjF5fgEh/yELdGV/MhIovNtniopZ73GfV3kRq5jbaU14x3KDq5/V
         0oAWKsZW9ihRy5BHyJk1ZJPRBk+VLLCq9sPMM=
Message-ID: <f17812d70810072340n6cb9bd21w1fcf73b56b4f8dff@mail.gmail.com>
Date: Wed, 8 Oct 2008 14:40:32 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: Toggling GPIO at 38Khz
Cc: "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2008 at 11:43 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
> I'm working on getring the LIRC IR subsystem integrated into the
> kernel. One common IR hardware implementation is based on standard
> serial ports. It uses the serial port's DCD and DTR as GPIO pins.
> This common IR hardware does not have a transmit modulator and is
> modulating the IR signal in software. Luckily is has hardware
> demodulation.
>
> There are four common IR frequencies - 36Khz, 38Khz, 40Khz, 56Khz. I
> need to create these frequencies in software. Data is then transmitted
> as 400-600us burst of these frequencies. Around 10-30 clock pulses.
>
> So how do I reliably generate 38Khz without destroying latency in the
> system? I also don't want to measure the speed of the code I'm
> executing - same code has to run on 90Mhz ARM and 3Ghz Core2. If a do
> a loop with nanosleep() I need to know how fast my code is to subtract
> it's execution time form the sleep time. The existing LIRC code works
> this way and measures it's timing loop.
>

This isn't easy, 38KHz is quite a high frequency, I'd prefer to
use an interrupt or fiq based on a accurate clock event source,
but that will have impact on the system anyway.

> hrtimers look promising, but hrtimers doesn't have a periodic API. Is
> there a technique for creating periodic timing that doesn't accumulate
> error caused by rescheduling the timers?  If I need to send 30 pulses
> of 38Khz, it is more important that the total time be (1/38000)*30 =
> 0.7894ms than it is for each pulse to be generated at exactly 26.3us
> intervals.
>

Make sure your clock source is accurate enough to generate
this interval.

> Are there other techniques for generating pulse trains in the 36-56Khz
> range on a simple GPIO pin? Anyone have some sample code?
>

With a PWM possibly.

> --
> Jon Smirl
> jonsmirl@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
