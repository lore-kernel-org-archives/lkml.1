Return-Path: <linux-kernel-owner+w=401wt.eu-S937146AbYD1Vev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937146AbYD1Vev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935551AbYD1Vel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:34:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:59167 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935206AbYD1Vej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:34:39 -0400
Message-ID: <481642EB.7010807@ct.jp.nec.com>
Date: Mon, 28 Apr 2008 14:34:35 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 1/4] x86_64: send NMI after nmi_show_regs on
References: <48161325.1080508@ct.jp.nec.com> <4816140F.50005@ct.jp.nec.com> <Pine.LNX.4.58.0804281457330.4615@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0804281457330.4615@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> On Mon, 28 Apr 2008, Hiroshi Shimamoto wrote:
>> diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
>> index d187ab9..69cc737 100644
>> --- a/arch/x86/kernel/nmi_64.c
>> +++ b/arch/x86/kernel/nmi_64.c
>> @@ -327,11 +327,11 @@ void nmi_show_all_regs(void)
>>  	if (system_state == SYSTEM_BOOTING)
>>  		return;
>>
>> -	smp_send_nmi_allbutself();
>> -
>>  	for_each_online_cpu(i)
>>  		nmi_show_regs[i] = 1;
> 
> Hi Hiroshi,
> 
> I know this wasn't your code to begin with but, how does this function
> exit?  I mean, we set an array where each index per online cpu is set to
> one, then do an "nmi_allbutself", and then wait on those indexes to turn
> zero, one at a time.  If we are CPU 0 here, we set that index to 1, then
> enter the loop, and will block forever on this "while" loop below.

Hm, I'm not quit sure when NMI disabled.
If NMI is working issuing CPU will receive NMI and the flag turns off in
NMI handler.
I'll look into it again and will work if needed.

thanks,
Hiroshi Shimamoto

