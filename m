Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbXGKVEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbXGKVEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933978AbXGKVCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:02:40 -0400
Received: from opinicus.com ([24.73.193.242]:46238 "EHLO thing2.opinicus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933886AbXGKVCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:02:39 -0400
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 17:02:39 EDT
Message-ID: <46954273.9090207@opinicus.com>
Date: Wed, 11 Jul 2007 16:49:55 -0400
From: William Montgomery <william@opinicus.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: e100 driver hard lockups with AEI-P430C 4 port card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The AEI-P430C PCI 10/100 Quad Fast Ethernet card causes two computers to 
lockup
hard but runs OK on a third computer.  I have spent several days trying to
determine the cause.  I have used the following OS/driver combos:

  Slackware 10.1 Linux kernel 2.6.17 / eepro100 / e100
  Slackware 10.1 Linux kernel 2.6.13 / eepro100 / e100
  Slackware 9.1 Linux kernel 2.4.22 / e100

The following computer hardware configurations were used:

PC_1: Rackmount Industrial PC (Advantech 4U chassis)
  12 slot PCI backplane (Advantech)
  Pentium 4 2.80GHz, 512M Ram  PCMIG (Advantech)

PC_2: Rackmount Industrial PC (Axiomtek 4U chassis)
  12 slot PCI backplane (Axiomtek)
  Pentium 4 3.00GHz, 512M Ram  PCMIG (Axiomtek)

PC_3: Desktop (ShuttleX)
  1 AGP, 1 PCI slot motherboard with Pentium 4 2.80GHz, 512M Ram

The hard lockups occur on PC_1 and PC_2 but not on PC_3.  I have used 
all three
OS/driver combos on PC_1 and PC_2 to try to eliminate the OS/driver as the
problem; in each case the lockup is repeatable within a few minutes of heavy
traffic.  The test script uses the "iperf" utility which measures 
bandwidth on
an ethernet port by moving as much data as possible in 10 seconds then
computing bandwidth.  The script runs iperf on 3 ports simultaneously and
repeats until killed.  I have tested the AEI card by connecting to 3 
separate
Intel PRO/100 S cards and (in trying a different configuration) by 
connecting
it to a Routerboard RB44 (4 port card).

I have tried the obvious methods to get an oops but no success so far.  
I have
enabled the Magic SysRq key and enabled the NMI watchdog.  The lockup is so
hard that none of these works.  The only thing that brings the CPU out 
of the
lockup is the i810 watchdog but that causes a reset/reboot and no oops so I
cant see any backtrace info.  Any suggestions would be welcome.

Regards,
William Montgomery

