Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbXG1U6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbXG1U6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbXG1U62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:58:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:40582 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752196AbXG1U61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:58:27 -0400
Date: Sat, 28 Jul 2007 22:55:14 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Christoph Pfister <christophpfister@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: keyboard stopped working after de9ce703c6b807b1dfef5942df4f2fadd0fdb67a
Message-ID: <20070728205514.GA17084@suse.cz>
References: <200707132249.26106.christophpfister@gmail.com> <200707132304.30795.christophpfister@gmail.com> <d120d5000707160749r1084ab4ex8d2c4e89e6134d41@mail.gmail.com> <200707172101.06878.christophpfister@gmail.com> <d120d5000707171252j501a25f5v56beae0c11462cb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000707171252j501a25f5v56beae0c11462cb9@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 03:52:07PM -0400, Dmitry Torokhov wrote:
> Hi Christoph,
> 
> On 7/17/07, Christoph Pfister <christophpfister@gmail.com> wrote:
> >
> >Yep, attached (cold reboot, not pressing any keys, 2.6.21).
> >
> 
> Ok, I see. You don't use PS/2 mouse and so BIOS told us that mouse is
> absent and reassigned IRQ12 to EHCI controller. However we do not
> listen to BIOS on i386 (for historucal reasons) and process with
> registering AUX port... Now IRQ12 is shared between AUX port and EHCI
> and the keyboard controller is unhappy wehereas before (with polling
> timer) it would release IRQ12 and close port...

Here I should add that IRQ sharing between ISA/LPC where i8042 lives and
PCI where EHCI lives doesn't work - only one of the sides will ever be
able to trigger interrupts, depending on the bridge config.

> Does your keyboard start working if you boot with i8042.noaux?

-- 
Vojtech Pavlik
Director SuSE Labs
