Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZD0SiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZD0SiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZD0SiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:38:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:19142 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbZD0SiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:38:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,255,1239001200"; 
   d="scan'208";a="407326368"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
CC: "Ma, Chinang" <chinang.ma@intel.com>, Andi Kleen <andi@firstfloor.org>,
       "willy@linux.intel.com" <willy@linux.intel.com>
Date: Mon, 27 Apr 2009 11:38:08 -0700
Subject: Discrepancies between Oprofile and vmstat
Thread-Topic: Discrepancies between Oprofile and vmstat
Thread-Index: AcnHBiuLvZL+M3DATBC2Ehj1YYPa3QAWOqaw
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com>
 <87ljpmk29b.fsf@basil.nowhere.org>
In-Reply-To: <87ljpmk29b.fsf@basil.nowhere.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using an OLTP-type workload on a fully saturated system and have begun seeing a discrepancy between the output of oprofile and vmstat on upstream kernels that was first seen with the 2.6.27 kernel.

Workload:
OLTP database workload using QLogic FC cards with MSI-X enabled doing ~50,000 IOPS

Oprofile (v0.9.3) collection methodology:
opcontrol --init
opcontrol --vmlinux=/usr/src/linux-`uname -r`/vmlinux
opcontrol -e=CPU_CLK_UNHALTED:80000 -e=LLC_MISSES:6000
opcontrol --start-daemon
sleep 5
opcontrol --start
sleep 60
opcontrol --stop
opcontrol --save=$1
opcontrol --deinit

Function classification:
Modules vmlinux and *.ko = kernel, all others = user.

Results (2.6.30-rc3 kernel):
vmstat reports ~75% user, 25% kernel
oprofile reports 70.3808% user, 29.6142% kernel 

Using another profiling tool to confirm, we see 74.784% user, 25.174% kernel.

Doug Styner
douglas.w.styner@intel.com
