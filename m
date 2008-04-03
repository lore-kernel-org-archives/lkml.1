Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYDCUuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYDCUuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbYDCUt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:49:58 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:24445 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299AbYDCUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:49:57 -0400
Message-ID: <47F542BE.3000106@gentoo.org>
Date: Thu, 03 Apr 2008 21:49:02 +0100
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux kernel <linux-kernel@vger.kernel.org>, kerframil@gmail.com,
       mpagano@gentoo.org, linux-kbuild@vger.kernel.org
Subject: x86: defconfig not being applied automatically in 2.6.24+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.23, if you unpacked a kernel source tarball and then ran "make 
menuconfig" you'd be presented with this message:
	# using defaults found in arch/i386/defconfig

and the default options would be set.

The same thing in 2.6.24 does not give you any "using defaults" message, 
and the default config options within menuconfig are rather blank (e.g. 
no PCI support). You can work around this by explicitly running "make 
defconfig" before menuconfig, but it would be nice to have the behaviour 
the way it was for 2.6.23 (and the way it still is for other archs).


I've looked into the problem. It works on 2.6.23 because of init/Kconfig 
which is still unchanged:

config DEFCONFIG_LIST
	[...]
	default "arch/$ARCH/defconfig"

arch/i386/defconfig and arch/x86_64/defconfig existed in 2.6.23, but not 
in 2.6.24 due to the arch merge.

I've identified why it worked in 2.6.23 but I'm not really sure of the 
right way to fix it for the newer kernels. I tried adding another 
default in DEFCONFIG_LIST:
	default "arch/$SRCARCH/configs/$KBUILD_DEFCONFIG"
but it seems that $SRCARCH and $KBUILD_DEFCONFIG are not being exported 
to kconfig and I couldn't immediately see how to change that.

Any thoughts?

Thanks,
Daniel
