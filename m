Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915Ab0ARLBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0ARLBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101Ab0ARLBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:01:04 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34347 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0ARLBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:01:01 -0500
Message-ID: <4B543F65.4040803@linux.vnet.ibm.com>
Date: Mon, 18 Jan 2010 16:30:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com> <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten> <20090820051038.GF21100@kryten> <20100118044142.GS12666@kryten> <20100118104213.64231c1e@mschwide.boeblingen.de.ibm.com> <20100118095527.GV12666@kryten>
In-Reply-To: <20100118095527.GV12666@kryten>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010 03:25 PM, Anton Blanchard wrote:
> 
> Hi Martin,
> 
>> For s390 the jiffies_to_cputime is a compile time constant. No need to
>> initialize it at runtime, no? 
> 
> Indeed it is, I didn't look closely enough. Same with ia64 so no work to
> do on either arch :)
> 
>> The patch itself trades some accuracy (larger cpu accounting value that
>> are stored per-cpu) against runtime overhead (spinlock to transfer the
>> value to the global variable in __percpu_counter_add). Did you
>> calculate how big the loss in accuracy is?
> 
> The idea is we are already batching percpu_counter_batch jiffies, so
> with CONFIG_VIRT_CPU_ACCOUNTING we batch the equivalent amount in
> cputime.
> 

This patch worked well for me.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir Singh.
