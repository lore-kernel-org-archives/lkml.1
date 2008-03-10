Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYCJPdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYCJPdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYCJPdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:33:04 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:52871 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYCJPdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:33:03 -0400
Message-ID: <47D5549D.8090402@tiscali.nl>
Date: Mon, 10 Mar 2008 16:32:45 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ego@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: Don't send RESCHEDULE_VECTOR to offlined cpus
References: <20080310121403.GD17646@in.ibm.com> <20080310122418.GA12101@elte.hu> <20080310125414.GE17646@in.ibm.com>
In-Reply-To: <20080310125414.GE17646@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
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

from arch/m32r/kernel/smp.c:134

void smp_send_reschedule(int cpu_id)
{
        WARN_ON(cpu_is_offline(cpu_id));
        send_IPI_mask(cpumask_of_cpu(cpu_id), RESCHEDULE_IPI, 1);
}

should this be changed as well?
