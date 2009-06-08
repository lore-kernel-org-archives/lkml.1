Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbZFHDKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbZFHDKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZFHDKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:10:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60094 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZFHDKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:10:09 -0400
Message-ID: <4A2C8105.9030503@jp.fujitsu.com>
Date: Mon, 08 Jun 2009 12:09:57 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
References: <1244085090.8361.360.camel@yhuang-dev.sh.intel.com>	 <4A28C2E2.4090309@jp.fujitsu.com>	 <1244189284.8361.514.camel@yhuang-dev.sh.intel.com>	 <4A28D738.8010202@jp.fujitsu.com>	 <1244191174.8361.517.camel@yhuang-dev.sh.intel.com>	 <4A2C66BF.5000401@jp.fujitsu.com> <1244426721.8361.569.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244426721.8361.569.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Emm, it seem hard to analyze mce_log_cpu from per_cpu_var(mce_log_cpus),
> how about following method:
> 
> struct mce_log {
>     char signature[12];
>     ...
>     struct mce_log_cpu *mcelog_cpus[];
> };
> 
> void mcelog_init(void)
> {
>     int cpu;
>     mcelog.mcelog_cpus = kmalloc(sizeof(void *) * num_possible_cpus();
>     for_each_possible_cpu(cpu)
> 	mcelog.mcelog_cpus[cpu] = &per_cpu(mce_log_cpus, cpu);
> }

It would be good.  Using kzalloc() will be better.
It might be a bit much, but how about adding:

+	mcelog.nr_mcelog_cpus = num_possible_cpus();

Be careful that mcheck_init(), caller of mcelog_init(), will be called
for each booted CPU.  You will need:

+	if (mcelog.mcelog_cpus)
+		return;


Thanks,
H.Seto

