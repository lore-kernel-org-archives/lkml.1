Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZKPVuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZKPVuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZKPVuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:50:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZKPVuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:50:20 -0500
Message-ID: <4B01C8B5.7060903@zytor.com>
Date: Mon, 16 Nov 2009 13:48:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration bootup
 messages
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210728.267482000@alcatraz.americas.sgi.com> <20091116212427.GC2221@elte.hu> <4B01C803.1010303@sgi.com>
In-Reply-To: <4B01C803.1010303@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2009 01:45 PM, Mike Travis wrote:
> 
> 
> Ingo Molnar wrote:
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>> --- linux.orig/init/calibrate.c
>>> +++ linux/init/calibrate.c
>>> @@ -123,23 +123,26 @@
>>>  {
>>>  	unsigned long ticks, loopbit;
>>>  	int lps_precision = LPS_PREC;
>>> +	bool boot_cpu = (smp_processor_id() == 0);
>>
>> this code is shared by other architectures too - are you sure 
>> smp_processor_id()==0 is a proper 'I am the boot CPU' assumption 
>> everywhere?
>>
>> 	Ingo
> 
> This was where having the boot_cpu_id would have been handy.
> 
> I could add something like:
> 
> --- linux.orig/init/main.c
> +++ linux/init/main.c
> @@ -539,13 +539,15 @@
>   *     Activate the first processor.
>   */
> 
> +int boot_cpu_id __read_mostly;
   ^^^^^^^^^^^^^^^
> +
>  static void __init boot_cpu_init(void)
>  {
> -       int cpu = smp_processor_id();
> +       int boot_cpu_id = smp_processor_id();
          ^^^^^^^^^^^^^^^
>         /* Mark the boot cpu "present", "online" etc for SMP and UP case */

Doesn't really work, does it?

I also still think that wrapping it in an inline would be good.

	-hpa
