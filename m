Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbXGNGIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbXGNGIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 02:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXGNGIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 02:08:06 -0400
Received: from [212.12.190.191] ([212.12.190.191]:33114 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751755AbXGNGIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 02:08:04 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Sat, 14 Jul 2007 09:07:54 +0300
User-Agent: KMail/1.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200707130808.31109.a1426z@gawab.com> <200707131828.54094.a1426z@gawab.com> <200707131750.31309.rjw@sisk.pl>
In-Reply-To: <200707131750.31309.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707140907.54607.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
>
> Hibernating process:
>
>   1. Normal kernel running
>   2. Hibernating is triggered, sys_kexec_load is used to load
>      hibernating kernel and initramfs into memory. Then
>      sys_reboot(LINUX_REBOOT_CMD_KSPAWN) is invoked.
>   3. In sys_reboot, kexec_jump is called to save device/CPU state,
>      then relocate_kernel is called. kexec_jump and relocate_kernel
>      reside in individual page in 16M~512M.
>   4. In relocate_kernel, 0~16M is backupped firstly, then the
>      hibernating kernel and initramfs is copied to 0~16M, after that,
>      the hibernating kernel is booted.
>   5. In hibernating kernel, the memory of normal kernel (it is in
>      16M~512M) is saved into a hibernation image through /dev/mem
>      and ELF header.
>
>
> Resume process:
>
>   1. Resuming kernel is booted as a normal kernel, but the memory is
>      restricted to 0~16M.
>   2. Checking whether there is a effective hibernation image. If
>      there isn't, the memory of 16M~512M is hot added, and the normal
>      boot up process continues; If there is, a resuming process is
>      triggered.
>   3. sys_kexec_load is used to restore the memory state of hibernated
>      kernel. The sys_kexec_load works in crashdump way, that is, the
>      hibernation image is copied to destination location in 16M~512M
>      in sys_kexec_load instead of relocate_kernel. There is no half
>      of memory size restriction.
>   4. sys_reboot is called to trigger jumping back, which will jump back
>      to kexec_jump of hibernated kernel.
>   5. In kexec_jump of hibernated kernel, the memory of 0~16M is copied
>      back from the backup area in 16M~512M. The memory state of
>      hibernated kernel is restored totally. The CPU and device state
>      can be restored after that.
>
>
> If there is too much difficulty to hot add memory in step 2. A more
> conservative method can be used as step 1 and step 2.
>
>   1. A normal kernel is booted.
>   2. Checking whether there is a effective hibernation image. If there
>      isn't, continue the normal boot process; otherwise, a resuming
>      kernel is kexeced in memory 0~16M. The resuming process will
>      continue in kexeced resuming kernel.

During Resume no kexec'ing is necessary; the normal kernel should be able to 
read the hibernation image via the /dev/snapshot interface.


Thanks!

--
Al

