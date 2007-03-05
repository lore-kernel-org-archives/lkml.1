Return-Path: <linux-kernel-owner+w=401wt.eu-S933509AbXCEPHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbXCEPHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933507AbXCEPHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:07:05 -0500
Received: from mxout-03.mxes.net ([216.86.168.178]:1557 "EHLO
	mxout-03.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509AbXCEPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:07:03 -0500
Message-ID: <34036.86.7.220.119.1173107218.squirrel@wmbeta.mxes.net>
In-Reply-To: <1173090919.6782.13.camel@daplas>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> 
    <20070305015039.GI3441@stusta.de> <1173090919.6782.13.camel@daplas>
Date: Mon, 5 Mar 2007 15:06:58 -0000 (GMT)
Subject: Re: [4/6] 2.6.21-rc2: known regressions
From: "Andrew" <andrew@nelless.net>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Reply-To: "Andrew" <andrew@nelless.net>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, March 5, 2007 10:35 am, Antonino A. Daplas wrote:
>
> This is not a framebuffer nor console problem.
>
>
> I think Andrew Nelless confirmed that the cause is from the above
> commit. How to fix it, I don't know.  Perhaps the acpi_skip_timer_override boot option has to
> be used.
>
> Tony
>

Yes, apologies for taking so long with this.
I tried the acpi_skip_timer_override boot option last night,
after Tony pointed it out, and this also works around the
problem.

To summarize the cause is the changes made to early-quirks.c
in the mentioned commit and when this is reverted the problem
goes away.

There doesn't seem to be any sign of a living HPET on this
board or any way of enabling it in the current BIOS revision
but it seems on intermittent boots the check in early-quirks.c
returns, the timer override doesn't happen, and the kernel
fails to boot properly.

Btw, this is the Asus A8N-VM *CSM* main board, the non-CSM
variety actually has a nForce 410 rather than an
nForce 430 chip. I don't know whether they behave any
differently but the two boards actually have different BIOS
releases.

If reverting the commit would disable the HPET on boards
that do actually support it I personally don't mind using
the acpi_skip_timer_override workaround.

-
  Andrew

