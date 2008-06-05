Return-Path: <linux-kernel-owner+w=401wt.eu-S1763051AbYFEWc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763051AbYFEWc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbYFEWcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:32:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:63004 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbYFEWcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:32:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,597,1204531200"; 
   d="scan'208";a="573089782"
Message-ID: <48486920.4040006@intel.com>
Date: Thu, 05 Jun 2008 15:30:56 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Brown, Len" <len.brown@intel.com>, cpufreq@lists.linux.org.uk,
       Dave Jones <davej@codemonkey.org.uk>
Subject: bug? acpi p-state + ondemand keeps dropping max freq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2008 22:32:39.0888 (UTC) FILETIME=[0FF7DD00:01C8C75C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've consistently experienced the following bizarre problem since 2.6.20, all the
way up to 2.6.25.3 (regressed yesterday and each of these kernels exposes this
behaviour):

/sys/devices/system/cpu/cpu0/cpufreq # grep . *
affected_cpus:0
cpuinfo_cur_freq:800000
cpuinfo_max_freq:1866000
cpuinfo_min_freq:800000
scaling_available_frequencies:1866000 1600000 1333000 1066000 800000
scaling_available_governors:ondemand performance
scaling_cur_freq:800000
scaling_driver:acpi-cpufreq
scaling_governor:ondemand
scaling_max_freq:800000
scaling_min_freq:800000



Notice that scaling_mx_freq dropped down to the lowest possible value and as such
my CPU is only working at 800MHz. At boot time this field properly displays
1866MHz and everything works OK. After a certain period (?) this value drops down
and I cannot manually elevate it back to the normal level:

# echo 1866000 > scaling_max_freq ; cat scaling_max_freq
800000
# echo 1866000 > scaling_max_freq ; cat scaling_max_freq
800000


This renders my Dothan to utterly poor speeds. (standard T43)

performance cpufreq governor makes no difference - I still can't change the
frequency upper/lower values.

Auke
