Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZKPVaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZKPVaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZKPVaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:30:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZKPVaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:30:07 -0500
Message-ID: <4B01C3DB.3040802@zytor.com>
Date: Mon, 16 Nov 2009 13:27:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
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
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210728.267482000@alcatraz.americas.sgi.com> <20091116212427.GC2221@elte.hu>
In-Reply-To: <20091116212427.GC2221@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2009 01:24 PM, Ingo Molnar wrote:
> 
> * Mike Travis <travis@sgi.com> wrote:
> 
>> --- linux.orig/init/calibrate.c
>> +++ linux/init/calibrate.c
>> @@ -123,23 +123,26 @@
>>  {
>>  	unsigned long ticks, loopbit;
>>  	int lps_precision = LPS_PREC;
>> +	bool boot_cpu = (smp_processor_id() == 0);
> 
> this code is shared by other architectures too - are you sure 
> smp_processor_id()==0 is a proper 'I am the boot CPU' assumption 
> everywhere?
> 

It really shouldn't be for x86 either, although right now we play nasty
renumbering games to accommodate that assumption.  It seems like we
really should have a boot_cpu_id() or some such.

	-hpa

