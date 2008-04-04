Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbYDDNlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbYDDNlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYDDNlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:41:37 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:6338 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYDDNlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jO7Tt4WRvOn8fsZBw8U6TCQ9nX3s+N+E07Br5vNhKUyfuugImPPSd2dOYpLq9owd+xz6RSvyWIrZPM61nPIlV1vIq6eDF6AWPFPoYeh95mSKOfpHGVMW52quYuZhUxqQXblxYMXtvLw7g66nrvkH2DSF94xH1G1BEMLxsC8ECBw=
Message-ID: <1ee641e10804040641m161482a1y620bbbcfc4385506@mail.gmail.com>
Date: Fri, 4 Apr 2008 15:41:31 +0200
From: "Simon Braunschmidt" <sbraunschmidt.linuxlists@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [kbuild, arch/arm] - kernel images do not reflect changed .config
Cc: arthur.mielimonka@teleca.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Problem:
After changing anything in the .config, updated objects get only into
arch/arm/boot/Image but not into the other targets.

Steps to reproduce:
-checkout clean 2.6.24
-change in Makefile:
ARCH=arm
CROSS_COMPILE=arm-none-linux-gnueabi- (codesourcery toolchain to
support armv7 (cortex a8))
then:
#make integrator_defconfig (I tried integrator_defconfig and
omap_osk_5912_defconfig)
#make uImage
#ls -la arch/arm/boot
#ls -la arch/arm/boot/compressed
-note the size of :
boot/Image
boot/zImage
boot/uImage
compressed/vmlinux
compressed/piggy.gz
compressed/piggy.o

-now change the .config, for example deactivate FP emulator and
binformat support
-save your .config
#make distclean
-restore your .config
#make uImage

only boot/Image and compressed/piggy.gz will have changed, even after
distclean. Weird.

Is this already fixed? I'm sorry I cannot check easily since i'm not
allowed to use git in my corporate environment. *duck*

Regards, Gruessla
Simon Braunschmidt
