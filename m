Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbXLMOwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbXLMOwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbXLMOvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:51:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760710AbXLMOvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:51:52 -0500
Message-ID: <4761469B.9060507@redhat.com>
Date: Thu, 13 Dec 2007 12:50:03 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 19/19] unify set_tss_desc
References: <1197511363887-git-send-email-gcosta@redhat.com> <11975113672937-git-send-email-gcosta@redhat.com> <11975113721808-git-send-email-gcosta@redhat.com> <11975113771692-git-send-email-gcosta@redhat.com> <11975113821418-git-send-email-gcosta@redhat.com> <11975113873364-git-send-email-gcosta@redhat.com> <11975113923422-git-send-email-gcosta@redhat.com> <11975113961144-git-send-email-gcosta@redhat.com> <1197511401733-git-send-email-gc!osta@redhat.com> <11975114062948-git-send-email-gcosta@redhat.com> <20071213124633.GG31699@bingen.suse.de>
In-Reply-To: <20071213124633.GG31699@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +static inline void pack_tss(tss_desc *tss, unsigned long addr,
>> +			   unsigned size, unsigned entry)
>> +{
>> +#ifdef CONFIG_X86_64
>> +		set_tssldt_descriptor(tss,
>> +			     addr, entry, size);
>> +#else
>> +		pack_descriptor(tss, (unsigned long)addr,
>> +				size,
>> +				0x80 | entry, 0);
> 
> It would be better if you just unified that first instead of ifdef'ing.
> I guess i386 could get a set_tssldt_descriptor() like wrapper
> around pack_descriptor(). 
Good point.

Thanks, Andi.


