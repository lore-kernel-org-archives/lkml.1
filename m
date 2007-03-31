Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbXCaIMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbXCaIMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXCaIMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:12:20 -0400
Received: from gw.goop.org ([64.81.55.164]:34997 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbXCaIL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:11:56 -0400
Message-ID: <460E17CB.6010609@goop.org>
Date: Sat, 31 Mar 2007 01:11:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VMI paravirt-ops bugfix for 2.6.21
References: <460E1FC7.5030107@vmware.com> <20070331010213.b7aa4656.akpm@linux-foundation.org>
In-Reply-To: <20070331010213.b7aa4656.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 31 Mar 2007 00:45:59 -0800 Zachary Amsden <zach@vmware.com> wrote:
>
>   
>> +static void vmi_set_lazy_mode(int new_mode)
>> +{
>> +	static DEFINE_PER_CPU(int, mode);
>> +	static DEFINE_PER_CPU(unsigned long, flags);
>> +	int cpu = smp_processor_id();
>>     
>
> That will cause upset if CONFIG_PREEMPT=y?
>   

It must be called under the pagetable lock, so preempt should already be
disabled.

    J
