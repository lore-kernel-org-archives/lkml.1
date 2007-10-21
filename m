Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbXJULQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbXJULQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXJULQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:16:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:50329 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751511AbXJULQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:16:18 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18smbdr36AsyZMO5raSMpXG9Qftjp3LOGmznYbdwG
	rl3gljOgRxwbx5
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: cpu governor ondemand issue
Date: Sun, 21 Oct 2007 13:16:14 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200710211316.14955.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I use the following one liner for regression tests of the cpufreq governor and
friends:

tfoerste@n22 ~ $ time factor 819734028463158891

which usually needs 5.5 secs to complete at 1.7 GHz of my pentium M processor.

With the  current git sources (commit cfa76f0 at Sat Oct 20 20:19:15 2007 -0700)
instead this command needs 3 times longer if I run the "distributed.net client"
as a background process with nice level 19 b/c the cpu frequency still stays
at 600 MHz.
After stopping dnetc the cpu frequency governor ondemand works as expected again.

Tested at my ThinkPad T41 with stable Gentoo:

tfoerste@n22 ~ $ grep -e ^CONFIG_ACPI -e ^CONFIG_CPU_FREQ_GOV_ ~/devel/linux-2.6/.config
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y

-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
