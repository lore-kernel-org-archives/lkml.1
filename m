Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbYCFIRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbYCFIRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYCFIRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:17:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34607 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760732AbYCFIRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:17:21 -0500
Date: Thu, 6 Mar 2008 08:16:58 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [JANITOR-PATCH] rtc: switch to unlocked_ioctl
Message-ID: <20080306081658.GA21135@flint.arm.linux.org.uk>
References: <1204664803.5698.27.camel@brick> <47CDD3F9.7070801@gmail.com> <200803051116.45769.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803051116.45769.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 11:16:45AM +0100, Andi Kleen wrote:
> One easy way to do that is to do an allyesconfig build once and
> save the log

Don't bother.  As I keep saying and have been saying since the all*config
targets were introduced, they're useless for ARM, because ARM is soo
diverse.

You need to find a platform configuration which uses the file.

Eg,

$ grep rtctime arch/arm/common/Makefile
obj-y                           += rtctime.o

In this case, any one will do.

But lets say you modify arch/arm/common/uengine.c:

$ grep uengine arch/arm/common/Makefile
obj-$(CONFIG_ARCH_IXP2000)      += uengine.o
obj-$(CONFIG_ARCH_IXP23XX)      += uengine.o
$ grep CONFIG_ARCH_IXP2000= arch/arm/configs/*
arch/arm/configs/ixp2000_defconfig:CONFIG_ARCH_IXP2000=y
$ grep CONFIG_ARCH_IXP23XX= arch/arm/configs/*
arch/arm/configs/ixp23xx_defconfig:CONFIG_ARCH_IXP23XX=y

So now you know you need to use ixp2000_defconfig or ixp23xx_defconfig as
a basis for building uengine.c.  (which is reasonable because it's an
IXP2000 or IXP2300 specific support file.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
