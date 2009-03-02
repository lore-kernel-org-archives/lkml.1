Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZCBPOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZCBPOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZCBPOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:14:06 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:47603 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZCBPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:14:04 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2009 10:14:04 EST
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       cpufreq@vger.kernel.org, davej@redhat.com
Subject: 2.6.28 - 2.6.29-rc6-git5 regression, p4-clockmod/cpufreq probably
Date: Mon, 2 Mar 2009 17:04:59 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021704.59663.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me, i am not on linux-kernel maillist

Hardware: Asus EEE 702, 
CPU: Intel Celeron 900 Mhz

On 2.6.28 p4-clockmod available, and i can manage governor, frequency and etc 
over cpufrequtils.
On 2.6.29-rc6 (git5 tested also) also shown in dmesg as available, but i  
can't change anything.

root # cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  no or unknown cpufreq driver is active on this CPU

There is no noticeable differences in dmesg.
Both have
[    2.438474] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation 
available


Here is end of strace on cpufreq-info
lstat64("/sys/devices/system/cpu/cpu0/", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
lstat64("/sys/devices/system/cpu/cpu0/", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
write(1, "analyzing CPU 0:\n"..., 17analyzing CPU 0:
)   = 17
stat64("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq", 0xbfbce570) 
= -1 ENOENT (No such file or directory)
open("/proc/sys/cpu/0/speed", O_RDONLY) = -1 ENOENT (No such file or 
directory)
stat64("/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq", 0xbfbce570) 
= -1 ENOENT (No such file or directory)
stat64("/sys/devices/system/cpu/cpu0/cpufreq/scaling_driver", 0xbfbce580) = -1 
ENOENT (No such file or directory)
write(1, "  no or unknown cpufreq driver is"..., 53  no or unknown cpufreq 
driver is active on this CPU
) = 53
stat64("/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus", 0xbfbce460) = -1 
ENOENT (No such file or directory)
stat64("/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq", 0xbfbce560) 
= -1 ENOENT (No such file or directory)
stat64("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies", 
0xbfbce460) = -1 ENOENT (No such file or directory)
stat64("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors", 
0xbfbce560) = -1 ENOENT (No such file or directory)
stat64("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor", 0xbfbce570) 
= -1 ENOENT (No such file or directory)

If you need more information, let me know.
