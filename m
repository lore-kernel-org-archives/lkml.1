Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZDEGU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZDEGU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 02:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbZDEGUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 02:20:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:3464 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZDEGUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 02:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=l5hLe98Wz8KyamXxInUqCuq4O0K7eZHU5KkOrgOk0sfgvHqKHIAkg92PUCD93HMGtu
         OxEfF2/UOvJfcOEH+HGE3Z8LpVih2qV/1PVfILkPp+vSpulbAWBFN0BieaFxmjxEZqWr
         tyHP/Q+Em5JSuI2kClHXbk/+BsSDKICRpjQ+I=
MIME-Version: 1.0
Date: Sun, 5 Apr 2009 02:20:09 -0400
Message-ID: <bf8f81390904042320h4c0a0a3bv5dd7d33aa69a5287@mail.gmail.com>
Subject: Questions on userspace cpu freq governor for linux-2.6-tip
From: Luke Gong <lukejgong@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I have compiled the latest -tip kernel (2.6.29-tip). I enabled
userspace governor for cpu freq scaling. When I am running this new
kernel with userspace governor, I found something strange. At first, I
set the cpu freq scaling governor to be userspace and set all the
cores to run at the lowest speed. But when the machine is busy, I
found the cpu speed increased and would not stay at the level set by
the userspace governor. In the kernels other than this -tip one, I
never saw this before. I am wondering if I have missed something or it
is a bug for linux -tip kernel.

Here is the snapshot:

[root@cic112 ~]# cat /sys/devices/system/cpu/cpu0/
cpufreq/scaling_governor
userspace
[root@cic112 ~]# echo 2000000 >
/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
[root@cic112 ~]# cat
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
2000000
***********************************
Then I start to run a cpu-intensive workload, now the speed increases.
***********************************
[root@cic112 ~]# cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
3000000

I am using a server with 2 Xeon5450 Quad core with cpu freq from 2GHz
to 3GHz. Any comment is welcome and appreciated to be CCed to me.

Thanks.

-- 
Luke
