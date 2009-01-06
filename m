Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZAFGUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZAFGUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZAFGUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:20:42 -0500
Received: from bureau63.ns.utoronto.ca ([128.100.132.160]:56560 "EHLO
	bureau63.ns.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZAFGUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:20:41 -0500
X-Greylist: delayed 2372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 01:20:41 EST
Message-ID: <20090106004107.rb5znb3l44ss0gg4@webmail.utoronto.ca>
Date: Tue, 06 Jan 2009 00:41:07 -0500
X-ID: zhaoyuto
From: yutong.zhao@utoronto.ca
To: linux-kernel@vger.kernel.org
Subject: kexec unable to load crash kernel in X
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2009.1.6.52830
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linux-kernel,

I've been trying to track a hard lock kernel panic since 2.6.24, and  
it persists in 2.6.28. I've set up kexec as per the instructions in  
/Documentation/kdump/kdump.txt. I've enabled sysrq in both the kernel,  
AND, in /etc/sysctl.conf

The system responds to sysrq-C when I'm in the console and before  
startx. Thus, properly loading the dump kernel and allowing me access  
to /proc/vmcore

However, when I'm in X (after startx), sysrq-c does NOT load up the  
crash kernel, and instead hangs system (no blinking capslock though).  
I see some flashing hard drive activity, yet nothing changes on the  
screen as it still shows a frozen snapshot of X. This is true with  
both nv (with proper modprobe -r nvidia), and nvidia modules.

I'm on a Thinkpad T61P Intel Core 2 Duo, 2.5GHZ, x86_64, 2GB Memory,  
NVIDIA QUADRO FX 570M, and note that my CONFIG_PHYSICAL_START is  
0x200000, NOT 0x100000, (I wasn't sure if this should be changed as  
the default was 0x200000, possibly due to Core 2?). But this shouldn't  
matter because the kernel is RELOCATABLE(=y).. right?

I've attached my:

.config : http://dpaste.com/105844/
lspci : http://dpaste.com/105846/
lsmod : http://dpaste.com/105848/
dmesg : http://dpaste.com/105849/
grub.conf : http://dpaste.com/105850/, most relevant boot config  
system kernel is "kernel /boot/kernel-2.6.28-gentoo-custom  
root=/dev/sda3 pci=nommconfig idle=poll crashkernel=128M@16M" note  
that /boot/kernel-2.6.28-gentoo-custom corresponds to the bzImage used  
in kexec.

my kexec command is "sudo kexec -p  
/usr/src/linux-2.6.28-gentoo/arch/x86/boot/bzImage  
--append=root=/dev/sda3 1 irqpoll maxcpus=1 reset_devices"

Please assist and CC me in all messages/comments/answers.


-Yutong Zhao

