Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbYBGONv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbYBGONv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYBGONk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:13:40 -0500
Received: from mail.syneticon.net ([213.239.212.131]:54670 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYBGONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:13:39 -0500
Message-ID: <47AB120A.1000600@wpkg.org>
Date: Thu, 07 Feb 2008 15:13:30 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: why kexec insists on syncing with recent kernels?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to kernel/kexec.c:

  * kexec does not sync, or unmount filesystems so if you need
  * that to happen you need to do that yourself.


I saw this was true with 2.6.18 kernel (i.e., it didn't sync), but kexec 
syncs with recent kernels (I checked 2.6.23.14 and 2.6.24):

# kexec -e
md: stopping all md devices
sd 2:0:0:0: [sdb] Synchronizing SCSI cache


With kexec on 2.6.18 it was executing a loaded kernel immediately.


Generally, it's a good thing to sync before jumping into a new kernel, 
but it breaks my setup here after upgrading from 2.6.18 to 2.6.24.

Why?

I have a couple of diskless (iSCSI-boot) machines with a buggy BIOS (old 
Supermicro P4SBR/P4SBE) which randomly freeze after rebooting (the 
machine shuts down just fine, but instead of booting again, showing BIOS 
bootup messages etc. you can just see blank screen).

Therefore, I use kexec as a workaround for this rebooting problem.

The way kexec works now makes rebooting unreliable again:
- network interfaces are brought down,
- kernel tries to sync - it never will, as we're booted off network, 
which is down

Any ideas why kexec insists on syncing?


-- 
Tomasz Chmielewski
http://blog.wpkg.org
