Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZFJFcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZFJFcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZFJFb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:31:56 -0400
Received: from mga05.intel.com ([192.55.52.89]:19155 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860AbZFJFbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:31:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,338,1241420400"; 
   d="scan'208";a="465030576"
Date: Wed, 10 Jun 2009 13:15:21 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Fix incorrect default branch
Message-ID: <20090610051521.GB30923@ywang-moblin2.bj.intel.com>
References: <20090609074621.GA19290@ywang-moblin2.bj.intel.com> <20090609132313.GE25586@elte.hu> <20090609133232.GA14642@ywang-moblin2.bj.intel.com> <20090609142506.GD32703@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609142506.GD32703@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 04:25:06PM +0200, Ingo Molnar wrote:
> 
> They dont have X86_FEATURE_ARCH_PERFMON set, right?
> 
> I made the switch statement under the assumption that it covers all 
> existing arch-perfmon CPU models. If not, the 'default:' placement 
> would indeed be buggy.
> 

OK, you are right. X86_FEATURE_ARCH_PERFMON eliminates all the old CPUs.
However, the logic still seems not correct. Both the Core2 CPUs I'm
using are recognized as Nehalem/Corei7. /proc/cpuinfo and cpuid outputs
are given below.

The first one:
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
stepping        : 6

CPUID.0x00000001: eax=0x00010676

The second one:
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping        : 6

CPUID.0x00000001: eax=0x000006f6

Looks like it's not enough to just look at boot_cpu_data.x86_model.

-Yong
