Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbYHFN6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbYHFN6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYHFN5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:57:45 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:34505 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYHFN5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:57:44 -0400
Message-ID: <44718.166.70.238.45.1218029800.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080806084014.GA3777@in.ibm.com>
References: <200808050626.m756QZ1g003755@wolfmountaingroup.com>
    <20080806084014.GA3777@in.ibm.com>
Date: Wed, 6 Aug 2008 07:36:40 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc1-git5 2/26] mdb: correct kprobes int3 trap
From: jmerkey@wolfmountaingroup.com
To: ananth@in.ibm.com
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

> On Tue, Aug 05, 2008 at 12:26:35AM -0600, jmerkey@wolfmountaingroup.com
> wrote:
> ...
>
>> @@ -850,6 +871,10 @@
>>  #ifdef CONFIG_KPROBES
>>  void __kprobes do_int3(struct pt_regs *regs, long error_code)
>>  {
>> +#ifdef	CONFIG_MDB
>> +        if (mdb(BREAKPOINT_EXCEPTION, error_code, regs))
>> +           return;
>> +#endif // CONFIG_MDB
>>  	trace_hardirqs_fixup();
>>
>>  	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
>
> Kprobes needs to be the first consumer of these exceptions (via
> notify_die); if the exception was due to a kprobe, it does its thing
> without requiring any user intervention. Here, for example, you can get
> into mdb for a kprobe breakpoint hit.
>
> Please move the mdb hooks to after kprobes has been notified. Better
> still, integrate mdb to use the notify_die infrastructure and use a
> lower priority than what kprobes does for it.
>
> Ananth
>

I have removed these hooks already and converted to debugger to use
notify_die -- finished it last night as per Andi's suggestions.  This code
section has already been removed from reboot.c and traps_XX.c.

I'll post the new patch with the module based debugger later today.

Jeff

