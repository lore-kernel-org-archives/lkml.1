Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbXKGLtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbXKGLtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 06:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXKGLtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 06:49:15 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:52730 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXKGLtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 06:49:14 -0500
Date: Wed, 07 Nov 2007 06:49:01 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2.6.24-rc2=another train wreck with amanda
To: linux-kernel@vger.kernel.org
Message-id: <200711070649.02136.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I have this line in my /etc/modprobe.conf:
options dm-mod major=238

And I had a fsckup while building 2.6.24-rc2 cuz I thought it needed to be 
based on 2.6.23.1 that has made 2.6.24-rc2 the only kernel that will boot 
without a panic, killing init message.

I can survive that, but amanda (tar) went bonkers last night and tried to do a 
level 0 on everything, which is about 50GB, but its virtual tape size is only 
11GB.

The last time this happened that line above fixed the device mapper to a 
stable address at a major of 238 which tar was happy with.

An ls -l of /dev/mapper:
[root@coyote /]# ls -l /dev/mapper
total 0
crw------- 1 root root  10, 62 Nov  6 23:40 control
brw-rw---- 1 root disk 238,  0 Nov  6 23:40 VolGroup00-LogVol00
brw-rw---- 1 root disk 238,  1 Nov  6 23:40 VolGroup00-LogVol01

So that hasn't changed, so what did?  Amanda itself hasn't been changed in 
several months, running the 20070727 snapshot of amanda-2.5.2p1 all this 
time.  Tar was updated by smart or yumex 2 or 3 days back, so it worked 
correctly after the update.  That leaves something in 2.6.24-rc2.  I didn't 
build rc1.

Other than that, rc2 seems stable.  But auditd failed to start in the bootup 
sequence. I think that's minor and may predate this particular kernel.  
However, selinux did a relabel before it booted, could that be the cause?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
An adequate bootstrap is a contradiction in terms.
