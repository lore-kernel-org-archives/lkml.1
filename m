Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbXKMM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbXKMM0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXKMM0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:26:11 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:33863 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbXKMM0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:26:09 -0500
Message-ID: <473993B3.4060508@qumranet.com>
Date: Tue, 13 Nov 2007 14:08:19 +0200
From: Izik Eidus <izike@qumranet.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: "Dong, Eddie" <eddie.dong@intel.com>, kvm-devel@lists.sourceforge.net,
       jeremy@goop.org, linux-kernel@vger.kernel.org, hollisb@us.ibm.com,
       avi@qumranet.com
Subject: Re: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
References: <11945615632624-git-send-email-gcosta@redhat.com><11945615703593-git-send-email-gcosta@redhat.com>	<11945615751747-git-send-email-gcosta@redhat.com>	<10EA09EFD8728347A513008B6B0DA77A025DF8A2@pdsmsx411.ccr.corp.intel.com> <4739906B.2080103@redhat.com>
In-Reply-To: <4739906B.2080103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Nov 2007 12:09:56.0590 (UTC) FILETIME=[1B0648E0:01C825EE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Dong, Eddie escreveu:
>   
>>> +static void kvm_write_guest_time(struct kvm_vcpu *vcpu) +{
>>> +	struct timespec ts;
>>> +	int r;
>>> +
>>> +	if (!vcpu->clock_gpa)
>>> +		return;
>>> +
>>> +	/* Updates version to the next odd number, indicating
>>> we're writing */
>>> +	vcpu->hv_clock.version++;
>>> +	kvm_write_guest(vcpu->kvm, vcpu->clock_gpa,
>>> &vcpu->hv_clock, PAGE_SIZE);
>>> +
>>> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
>>> +			  &vcpu->hv_clock.last_tsc);
>>> +
>>> +	ktime_get_ts(&ts);
>>>       
>> Do we need to disable preemption here?
>>     
> After thinking for a little while, you are theoretically right.
> In the current state, we could even be preempted between all operations
> ;-) Maybe after avi's suggestion of moving the call to it it will end up
> in a preempt safe region, but anyway, it's safer to add the preempt
> markers here.
> I'll put it in next version, thanks
>   
note that you cant call to kvm_write_guest with preemption disabled 
(witch you do few lines below)
