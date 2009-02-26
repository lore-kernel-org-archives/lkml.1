Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZBZI70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZBZI70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbZBZI7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:59:04 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:43549 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbZBZI7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:59:01 -0500
Message-ID: <49A659D0.2040903@turknet.net.tr>
Date: Thu, 26 Feb 2009 10:58:56 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Failover Kernel
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2009 08:58:57.0257 (UTC) FILETIME=[754B1590:01C997F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm thinking about a kernel feature called "Failover Kernel". The basic 
idea is to put 2 kernels (One is running "Primary Kernel" and the next 
one is "Backup Kernel") into the memory for disaster recovery of kernel 
panic'ing/crashing.

This feature's working schema could be like this :

- "Backup Kernel" could be stated and loaded into the memory via a boot 
line option like : "failover_kernel=/boot/vmlinuz-2.6.26"
- Primary running kernel will send keepalives to the "Backup Kernel" to 
state that it's alive.
- Primary running kernel can write a journal (like the journaled 
filesystems.) about needed infos for the backup kernel to recover.
- When the primary kernel crashed and couldn't send anymore keepalives, 
the backup kernel will recover from this journal to proceed to where the 
primary kernel left and will become primary.
- When "Backup Kernel" became "Primary" it will load the previous one as 
"Backup Kernel" again or maybe it could be left to manual. User could 
decide after the disaster recovery which kernel will be load as backup 
via a utility like "kexec".
- At kernel compile time, user can choose the the timing for failover 
kernel. For example, "Recover After 10 MS. of inactivity (not receiving 
keepalives). "


The usage scenarios of this feature could be :

- For people whose Datacenter is remote, it's a big problem when you 
compiled a new kernel and rebooting into a crashing/non-booting new 
kernel. You left with a completely crashed and non-functioning system. 
Hard reset and manual action is required. If there could be "Failover 
Kernel feature, the system will simply switch back to the "Backup 
Kernel" (This backup kernel will be the known stable kernel of the 
system.) and the system will proceed to work without any manual action 
required.

- Your system runs fine for the last several months and one day you hit 
a bug and kernel crashed/panic'ed . With "Failover Kernel", the system 
will switch to the "Backup Kernel" quickly (maybe some milliseconds or 
few seconds.) to recover and the system could proceed to work normally.

So,I'm not a coder and I don't know it is really possible as technically 
or not. You the kernel hackers, what's your opinion about it ? Could it 
be really possible ? If so, how we really can implement it ?

Many thanks for reading this long (and maybe stupid) post! :-)

Tarkan ERIMER


