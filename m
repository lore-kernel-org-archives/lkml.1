Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZHGIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZHGIS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZHGIS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:18:28 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28221 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033AbZHGIS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:18:27 -0400
X-IronPort-AV: E=Sophos;i="4.43,340,1246831200"; 
   d="scan'208";a="30885698"
Message-ID: <4A7BE35F.4060604@inria.fr>
Date: Fri, 07 Aug 2009 10:18:39 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
References: <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr> <20090807063226.GA29532@elte.hu> <4A7BD9EC.8000801@inria.fr> <20090807074525.GA20292@elte.hu>
In-Reply-To: <20090807074525.GA20292@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I completely forgot about it. And since we now have --scale enabled 
> by default (and it doesnt make much sense to disable it i guess), it 
> would not be a big issue to rename that -c/--scale to free up that 
> flag for -S/--stat?
>
> 	Ingo
>   


Here you are. But how do you switch "scale" off now that it's disabled
by default?
I tried --scale=0, --no-scale and so on without apparently succeeding.

Brice

[PATCH] perf stat: change -S for --scale into -c

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>

Index: linux-rc/tools/perf/Documentation/perf-stat.txt
===================================================================
--- linux-rc.orig/tools/perf/Documentation/perf-stat.txt	2009-08-07 10:09:40.000000000 +0200
+++ linux-rc/tools/perf/Documentation/perf-stat.txt	2009-08-07 10:09:46.000000000 +0200
@@ -40,7 +40,7 @@
 -a::
         system-wide collection
 
--S::
+-c::
         scale counter values
 
 EXAMPLES
Index: linux-rc/tools/perf/builtin-stat.c
===================================================================
--- linux-rc.orig/tools/perf/builtin-stat.c	2009-08-07 09:46:49.000000000 +0200
+++ linux-rc/tools/perf/builtin-stat.c	2009-08-07 10:07:44.000000000 +0200
@@ -496,7 +496,7 @@
 		    "stat events on existing pid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('S', "scale", &scale,
+	OPT_BOOLEAN('c', "scale", &scale,
 		    "scale/normalize counters"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),


