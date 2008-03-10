Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYCJQhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYCJQhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYCJQhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:37:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:8188 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYCJQhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=L9qwnqPWNX2VPYNFzzUBvOdX5RpYrFPiSe/8GKltPnzULqIAptD0m/54/AtDlwFdYjqrTomm1s0SlKvYrnPii46+qQQLjOZoEQ9n4ygT1FmszNAJUXoUEhR4EtuyB5Ip9zs++HbQKH4MLuZ/hnCL0IP0HsPejL9ttHZguEv8zh8=
Message-ID: <47D56399.1020504@gmail.com>
Date: Mon, 10 Mar 2008 12:36:41 -0400
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: ego@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: Don't send RESCHEDULE_VECTOR to offlined cpus
References: <20080310121403.GD17646@in.ibm.com> <20080310122418.GA12101@elte.hu> <20080310125414.GE17646@in.ibm.com>
In-Reply-To: <20080310125414.GE17646@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> On Mon, Mar 10, 2008 at 01:24:18PM +0100, Ingo Molnar wrote:
>> * Gautham R Shenoy <ego@in.ibm.com> wrote:
>>
>>> x86: Don't send RESCHEDULE_VECTOR to offlined cpus.
>>> From: Gautham R Shenoy <ego@in.ibm.com>
>>>
>>> In the x86 native_smp_send_reschedule_function(), don't send the IPI 
>>> if the cpu has gone offline already. Warn nevertheless!!
>> have you seen this happen?
> 
> Yup, this afternoon while running
> cpu-hotplug stress tests (http://lkml.org/lkml/2008/3/3/11)
> in parallel with kern-bench, I got this on the serial console.

Note that this may be a side-effect of the bug we are chasing with the 
rd->online problem.

E.g. if the rd->online issue is causing us to route tasks to dead CPUs, 
this phenomenon would probably go away once rd->online is fixed (which I 
believe it is with the patches that were submitted).

Regards,
-Greg
