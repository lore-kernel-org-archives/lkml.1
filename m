Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZFJLBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZFJLBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZFJLBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:01:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57113 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZFJLBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:01:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yong Wang <yong.y.wang@linux.intel.com>
Subject: Re: [PATCH -tip] perf_counter/x86: Fix the model number of Intel Core2 processors
Date: Wed, 10 Jun 2009 13:01:08 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <20090610090612.GA26580@ywang-moblin2.bj.intel.com>
In-Reply-To: <20090610090612.GA26580@ywang-moblin2.bj.intel.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906101301.08483.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18bOr/b9nmWG07VS6BbqmwbG7+TaD+G4Mr/zQY
 7ZXkAEzw9VHA1hFcnp0auIVNS3CuU3kI6giOU898ix05YyC6lf
 ngMEqz2rtiyNz+I61sXNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009, Yong Wang wrote:
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 40978aa..a49a82c 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -1407,7 +1407,8 @@ static int intel_pmu_init(void)
>          * Install the hw-cache-events table:
>          */
>         switch (boot_cpu_data.x86_model) {
> -       case 17:
> +       case 15:
> +       case 23:
>                 memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
>                        sizeof(hw_cache_event_ids));

There are actually four model numbers that refer to the same
core microarchitecture:

model 15: original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe"
model 22: single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L"
model 23: current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale"
model 29: six-core 45 nm xeon "Dunnington"

You should probably list all of them here.

	Arnd <><
