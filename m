Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYBQPGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYBQPGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbYBQPFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:05:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:53583 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbYBQPFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:05:43 -0500
Date: Sun, 17 Feb 2008 16:05:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 17/27] acer-wmi: fix section mismatch warnings
Message-ID: <20080217150551.GB12982@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org> <1203250984-11285-17-git-send-email-sam@ravnborg.org> <200802171303.56229.carlos@strangeworlds.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802171303.56229.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 01:03:55PM +0000, Carlos Corbacho wrote:
> On Sunday 17 February 2008 12:22:54 Sam Ravnborg wrote:
> > Fix following warnings:
> > WARNING: vmlinux.o(.text+0x672615): Section mismatch in reference from the
> > function acer_platform_remove() to the function
> > .exit.text:acer_backlight_exit() WARNING: vmlinux.o(.devinit.text+0x1e859):
> > Section mismatch in reference from the function acer_platform_probe() to
> > the function .init.text:acer_led_init() WARNING:
> > vmlinux.o(.devinit.text+0x1e878): Section mismatch in reference from the
> > function acer_platform_probe() to the function
> > .init.text:acer_backlight_init()
> >
> > Remove __exit annotation from acer_backlight_exit(). We cannot reference
> > a __exit annotated function from non __exit functions.
> >
> > acer_led_init() and acer_backlight_init() where both annotated __init but
> > used from a __devinit function. This would result in an oops should
> > gcc drop their inlining and the module are hot plugged.
> >
> > Fix by annotating acer_led_init() and acer_backlight_init() __devinit.
> >
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
> 
> > Cc: Len Brown <len.brown@intel.com>
> 
> Len, can you apply this to acpi-test? (Unless Andrew wants to take all these 
> through -mm?)

Thanks for the quick reply Carlos.

	Sam
