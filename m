Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878Ab0AEQAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0AEQAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855Ab0AEQAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:00:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab0AEQAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:00:45 -0500
Message-ID: <4B4361EE.2030201@redhat.com>
Date: Tue, 05 Jan 2010 10:59:42 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Jun Koi <junkoi2004@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, hpa@zytor.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 00/12] KVM: Add host swap event notifications for PV
 	guest
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> <fdaac4d51001050705s3f46dd0fi948a3b3ea803fa51@mail.gmail.com>
In-Reply-To: <fdaac4d51001050705s3f46dd0fi948a3b3ea803fa51@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 10:05 AM, Jun Koi wrote:
> On Tue, Jan 5, 2010 at 11:12 PM, Gleb Natapov<gleb@redhat.com>  wrote:
>> KVM virtualizes guest memory by means of shadow pages or HW assistance
>> like NPT/EPT. Not all memory used by a guest is mapped into the guest
>> address space or even present in a host memory at any given time.
>> When vcpu tries to access memory page that is not mapped into the guest
>> address space KVM is notified about it. KVM maps the page into the guest
>> address space and resumes vcpu execution. If the page is swapped out
>> from host memory vcpu execution is suspended till the page is not swapped
>> into the memory again. This is inefficient since vcpu can do other work
>> (run other task or serve interrupts) while page gets swapped in.
>>
>> To overcome this inefficiency this patch series implements "asynchronous
>> page fault" for paravirtualized KVM guests. If a page that vcpu is
>> trying to access is swapped out KVM sends an async PF to the vcpu
>> and continues vcpu execution. Requested page is swapped in by another
>> thread in parallel.  When vcpu gets async PF it puts faulted task to
>> sleep until "wake up" interrupt is delivered. When the page is brought
>> to the host memory KVM sends "wake up" interrupt and the guest's task
>> resumes execution.
>>
>
> Is it true that to make this work, we will need a (PV) kernel driver
> for each guest OS (Windows, Linux, ...)?

This patch series contains the guest kernel code for Linux,
as well as the host side code.

-- 
All rights reversed.
