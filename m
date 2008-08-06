Return-Path: <linux-kernel-owner+w=401wt.eu-S1763769AbYHFBv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763769AbYHFBv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbYHFBpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:45:21 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:45685 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762892AbYHFBpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:45:17 -0400
Message-ID: <44644.166.70.238.45.1217985860.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <878wvb6i2o.fsf@basil.nowhere.org>
References: <51549.166.70.238.45.1217815820.squirrel@webmail.wolfmountaingroup.com>
    <878wvb6i2o.fsf@basil.nowhere.org>
Date: Tue, 5 Aug 2008 19:24:20 -0600 (MDT)
Subject: Re: [PATCH 2.6.26 2/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Andi Kleen" <andi@firstfloor.org>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'll post some patches with these changes and submit it as a module.  I
will of course need to patch the kernel to introduce the die notifiers
where
they are not and there's the issue of cross call NMI to stop other
processors on SMP.

That's the real issues, Andi, is the xcall stuff for IPC to control all
the processors.

Jeff


> jmerkey@wolfmountaingroup.com writes:
>> regs->ip)
>> -#ifndef CONFIG_KPROBES
>> +#if !defined(CONFIG_KPROBES) && !defined(CONFIG_MDB)
>>  DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
>>  #endif
>>  DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
>> @@ -733,6 +747,9 @@
>>  {
>>  	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
>> NOTIFY_STOP)
>>  		return;
>> +#ifdef	CONFIG_MDB
>> +        mdb(NMI_EXCEPTION, reason, regs); // nmi is code 2
>> +#endif
>
> This should be all using die notifiers (register_die etc.) like the
> other kernel debuggers, not own hooks. As you can see there is already
> a notify_die call around basically all the places you put in a mdb()
> call, and you can just hook in there. If your other interfaces to the core
> kernel are clean enough this would even allow to use your debugger as a
> module.
>
> -Andi
>


