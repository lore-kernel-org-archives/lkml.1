Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZBDL5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZBDL5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZBDL5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:57:07 -0500
Received: from relay.parallels.com ([195.214.232.42]:52299 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZBDL5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:57:06 -0500
X-Greylist: delayed 809 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 06:57:06 EST
From: Kirill Korotaev <dev@parallels.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Date: Wed, 4 Feb 2009 14:43:36 +0300
Subject: Re: [PATCH] x86: fix hpet timer reinit for x86_64
Thread-Topic: [PATCH] x86: fix hpet timer reinit for x86_64
Thread-Index: AcmGvUrhvwpSWPFpRxW9XyTYMxRG3AAAIWHd
Message-ID: <C5AF5A18.B6A4%dev@parallels.com>
In-Reply-To: <m3myd21ldn.wl%vmayatsk@redhat.com>
Accept-Language: en-US, ru-RU
Content-Language: en
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/4/09 2:39 PM, "Vitaly Mayatskikh" <v.mayatskih@gmail.com> wrote:

> At Wed, 04 Feb 2009 13:40:31 +0300, Pavel Emelyanov wrote:
>> 
>> There's a small problem with hpet_rtc_reinit function - it checks
>> for the
>>       hpet_readl(HPET_COUNTER) - hpet_t1_cmp > 0
>> to continue increasing both the HPET_T1_CMP (register) and the
>> hpet_t1_cmp (variable).
>> 
>> But since the HPET_COUNTER is always 32-bit, if the hpet_t1_cmp
>> is 64-bit this condition will always be FALSE once the latter hits
>> the 32-bit boundary, and we can have a situation, when we don't
>> increase the HPET_T1_CMP register high enough.
>> 
>> The result - timer stops ticking, since HPET_T1_CMP becomes less,
>> than the COUNTER and never increased again.
>> 
>> The solution is to cut the upper 32-bit from the hpet_t1_cmp
>> variable to make the comparison to HPET_COUNTER correct.
> 
> Why not to use u32 as a type for hpet_t1_cmp then?
> --
> wbr, Vitaly

Pavel, I agree, better please submit original fix
replacing unsigned long to unsigned int (or u32) in definition of
hpet_t1_cmp.

Thanks,
Kirill

