Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXBALLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXBALLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXBALLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:11:55 -0500
Received: from mout1.freenet.de ([194.97.50.132]:32865 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbXBALLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:11:54 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.20-rc6-mm3
Date: Thu, 1 Mar 2007 12:11:08 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070201080108.GC14378@elte.hu> <200702011144.43774.fzu@wemgehoertderstaat.de>
In-Reply-To: <200702011144.43774.fzu@wemgehoertderstaat.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011211.09055.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 1. Februar 2007 11:44 schrieb Karsten Wiese:
> I think the wait is caused by an interrupt starting somewhere under
> sysdev_resume(void).
> possibly lapic timer interrupt? Will try to trace that.

Some evidence:
[root@a64 Desktop]# echo reboot > /sys/power/disk
[root@a64 Desktop]# cat /proc/interrupts; echo disk > /sys/power/state ; cat /proc/interrupts
<snip>
LOC:    2215504
<snip, cmos clock untouched>
LOC:    2216432
<snip>
[root@a64 Desktop]# cat /proc/interrupts; echo disk > /sys/power/state ; cat /proc/interrupts
<snip>
LOC:    2225752
<snip, cmos clock advanced by 1 month under biossettings>
LOC:    2238383
<snip>

      Karsten


