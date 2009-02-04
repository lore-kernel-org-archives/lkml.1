Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbZBDLwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbZBDLwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZBDLv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:51:58 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:26708 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbZBDLv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:51:57 -0500
Message-ID: <4989814F.1030000@openvz.org>
Date: Wed, 04 Feb 2009 14:51:43 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] x86: fix hpet timer reinit for x86_64
References: <4989709F.1050207@openvz.org> <m3myd21ldn.wl%vmayatsk@redhat.com>
In-Reply-To: <m3myd21ldn.wl%vmayatsk@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh wrote:
> At Wed, 04 Feb 2009 13:40:31 +0300, Pavel Emelyanov wrote:
>> There's a small problem with hpet_rtc_reinit function - it checks
>> for the
>> 	hpet_readl(HPET_COUNTER) - hpet_t1_cmp > 0
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

That's the matter of taste from my POV, so I can re-send the patch
if x86 maintainers agree with your version.

> --
> wbr, Vitaly
> 

