Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbZEMQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbZEMQmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZEMQm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:42:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:35011 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759677AbZEMQm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:42:28 -0400
Message-ID: <4A0AF84F.6060809@kernel.org>
Date: Wed, 13 May 2009 09:41:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
References: <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org> <20090512150631.GA32067@elte.hu> <20090512164617.GA21673@elte.hu> <4A09C068.3010308@kernel.org> <20090512183302.GA4000@elte.hu> <4A09C157.7010407@kernel.org> <20090512190538.GA9769@elte.hu> <4A09CCBB.2000306@kernel.org> <20090513131405.GB21052@elte.hu>
In-Reply-To: <20090513131405.GB21052@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> -	return hard_smp_processor_id() >> index_msb;
>> +	return initial_apic_id >> index_msb;
> 
>> -	unsigned apicid = hard_smp_processor_id();
>> +	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
> 
>> -	int apicid = hard_smp_processor_id();
>> +	int apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
> 
> Doesnt such a pattern call for the pushing of that distinction into 
> hard_smp_processor_id() instead? (after a careful review of all 
> hard_smp_processor_id() call-sites)

don't want to burden system that have APIC to check that bit.

YH
