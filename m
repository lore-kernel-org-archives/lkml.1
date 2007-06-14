Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbXFNXvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbXFNXvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXFNXvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:51:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56078 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbXFNXvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:51:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: caglar@pardus.org.tr
Cc: linux-kernel@vger.kernel.org, horms@verge.net.au
Subject: Re: [2.6.22-rc4] kexec failed: invalid argument
References: <200706142109.46027.caglar@pardus.org.tr>
Date: Thu, 14 Jun 2007 17:49:19 -0600
In-Reply-To: <200706142109.46027.caglar@pardus.org.tr> (S.
 =?iso-8859-3?Q?=C7a=BBlar?= Onur's
	message of "Thu, 14 Jun 2007 21:09:41 +0300")
Message-ID: <m1hcpanlkw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-3
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"S.Ça»lar Onur" <caglar@pardus.org.tr> writes:

> Hi;
>
> With current Linus's git tree + current kexec-tools-testing [1] (also with 
> kexec-tools-1.101) tree "kexec -e" call on reboot failed with following;
>
> kexec failed: invalid argument
>
> kexec document says its users responsibility to close running softwares, 
> mounting disks in read only mode etc. and it suggest calling "kexec -e" just 
> before the "reboot" call and talks about future merge with sysvinit's reboot 
> and kexec, and when i did it, it will not starts new kernel and instead gaves 
> that error.
>
> But more supringuisly if i try to execute "kexec -e" directly (in init3 with 
> rw disks and lots of running software) it will starts new kernel without a 
> problem. 
>
> For reference im using following kexec line for loading the kernel
> kexec -l /boot/kernel-2.6.22-rc4-CFS-v16 --append="root=/dev/sda3"
> --initrd=/boot/initramfs-2.6.22-rc4-CFS-v16
>
> I'm not sure this is a regression or my(maybe me or kexec document misses some 
> point) mistake cause this is my first attempt to use kexec, but i want to 
> report the situation :)
>
>  [1] 
> http://git.kernel.org/?p=linux/kernel/git/horms/kexec-tools-testing.git;a=summary

Sight unseen I'm guessing that you have a kexec aware distro that is doing
something in the runlevel change scripts and thus unloading the kernel.
What do: /sys/kernel/kexec_loaded and /sys/kernel/kexec_crash_loaded say?

kexec -e at any point should start a loaded kernel without problems, but it is
a lot like pressing the reset button.  Nothing is guaranteed to be shutdown
cleanly.  Now that journalling filesystems are the norm it is quite possible
nothing bad will happen to you.




Eric
