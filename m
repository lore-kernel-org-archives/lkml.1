Return-Path: <linux-kernel-owner+w=401wt.eu-S1764790AbZFQJTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764790AbZFQJTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZFQJTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:19:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53461 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755229AbZFQJTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:19:02 -0400
Date: Wed, 17 Jun 2009 10:20:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Leo (Hao) Chen" <leochen@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm@lists.arm.linux.org.uk" <linux-arm@lists.arm.linux.org.uk>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Subject: Re: QUESTION: new arch/arm/mach-bcmring code submission
Message-ID: <20090617102011.41a3ecfa@lxorguk.ukuu.org.uk>
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADCB2592D730@SJEXCHCCR02.corp.ad.broadcom.com>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB2592D730@SJEXCHCCR02.corp.ad.broadcom.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. We have a whole lot of OS-less csp (chip support package) code that is used in our drivers and arch code. We will release them as GPL but we want to keep and maintain them in our own csp directories.  Can we put them under arch/arm/mach-bcmring/csp and arch/arm/mach-bcmring/include/csp directories?  If not, what's the proper way to do that?

Difficult to tell without seeing it.

> 2. We have driver header files which are currently kept in the include/linux/broadcom directory.  Where is the proper place to put our driver header files in Linux kernel?  Any guidelines?

Headers generally go in locations according to what they are for.

Thus

	arch/arm/plat-[name]/include/plat
	arch/arm/mach-[name]/include/mach

Stuff that defines public (user space) interfaces and structures tends to
be in include/linux while there are directories such as include/net/
include/usb/ - split by function rather than platform

> 3. Do I need to submit our code to any maintainer or just submit to LKML

Core changes that affect the internals of things like arch/arm and
include/asm-arm need to go via the maintainer (see MAINTAINERS): In this
case Russell King - and see: http://www.arm.linux.org.uk

After that platform changes can begin to go in, and then drivers. If you
are new to this then initially going through another maintainer will help
with quality and correctness, but after a time a lot of stuff would go
directly (stuff that affected only bcmring drivers/code). That also is a
good reason to keep as much of the code separated cleanly from the core
code as possible.
