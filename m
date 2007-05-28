Return-Path: <linux-kernel-owner+w=401wt.eu-S1763425AbXE1T0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763425AbXE1T0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXE1TZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:25:57 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4046 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbXE1TZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:25:57 -0400
Date: Mon, 28 May 2007 20:25:48 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ARM: Section mismatch warnings
Message-ID: <20070528192548.GD5737@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	LKML <linux-kernel@vger.kernel.org>
References: <20070528163253.GA29174@uranus.ravnborg.org> <20070528170430.GB5737@flint.arm.linux.org.uk> <20070528183629.GA30821@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528183629.GA30821@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 08:36:29PM +0200, Sam Ravnborg wrote:
> > 
> > > o-arm-neponset/log.out:WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x1748):
> >  Section mismatch: reference to .init.text:sa1110_mb_disable
> >  (between 'neponset_init' and 'neponset_resume')
> > 
> > This one looks quite bogus.  sa1110_mb_disable() is marked __init, and
> > it's called from neponset_init() which is also marked __init.
> 
> Created a neponset.i file - output:
> 
> static int neponset_init(void)
> {
>  platform_driver_register(&neponset_device_driver);
> 
> So we loose the __init marker during preprocessing.
> Which is due the the buggy part of my path that adds __devinit.
> 
> There was a reason I noted the devinit markers should be reviewed
> carefully - this one seems wrong.

I don't understand why you added that __devinit in the first place.
What happens if you leave it as a mere __init function, as it should be?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
