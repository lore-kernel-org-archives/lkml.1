Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784Ab0AHEtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0AHEtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 23:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620Ab0AHEtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 23:49:19 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:39441 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0AHEtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 23:49:18 -0500
Message-ID: <4B46B924.6070903@xenontk.org>
Date: Fri, 08 Jan 2010 10:18:36 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] generic-ipi: fix backtrace in smp_call_function_any()
References: <1262908019.2779.24.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1262908019.2779.24.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 05:16 AM, Suresh Siddha wrote:
> On my westmere box, I see this backtrace with 2.6.33-rc kernels:
> 
>> cpumask_of_node(3): node > nr_node_ids(1)
>> Pid: 1, comm: swapper Not tainted 2.6.33-rc3-00097-g2c1f189 #223
>> Call Trace:
>>  [<ffffffff81028bb3>] cpumask_of_node+0x23/0x58
>>  [<ffffffff81061f51>] smp_call_function_any+0x65/0xfa
>>  [<ffffffff810160d1>] ? do_drv_read+0x0/0x2f
>>  [<ffffffff81015fba>] get_cur_val+0xb0/0x102
>>  [<ffffffff81016080>] get_cur_freq_on_cpu+0x74/0xc5
>>  [<ffffffff810168a7>] acpi_cpufreq_cpu_init+0x417/0x515
>>  [<ffffffff81562ce9>] ? __down_write+0xb/0xd
>>  [<ffffffff8148055e>] cpufreq_add_dev+0x278/0x922
> 
> fix it by using the cpu_to_node() and using the node number instead
> of the cpu for cpumask_of_node().
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Hi Suresh,

I have already sent a patch for this:
http://www.gossamer-threads.com/lists/linux/kernel/1173978?do=post_view_threaded

Can you ACK that instead?

Regards,
David.

