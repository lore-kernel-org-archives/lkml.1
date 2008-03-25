Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYCYEqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYCYEqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 00:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYCYEq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 00:46:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55895 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYCYEq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 00:46:27 -0400
Message-ID: <47E88381.6030705@zytor.com>
Date: Mon, 24 Mar 2008 21:45:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable PAT for amd k8 and fam10h
References: <200803241602.01957.yhlu.kernel@gmail.com>	 <47E85593.4030104@zytor.com> <86802c440803241922u50fb33f8xb33118e22c2f7ad2@mail.gmail.com>
In-Reply-To: <86802c440803241922u50fb33f8xb33118e22c2f7ad2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>
>>  This really should be handled through a CPU flag.  Specifically, it
>>  should be handled by disabling the PAT flag if PAT is unusable or
>>  suspect of being unusable; it should *NOT* be stashed away in a
>>  completely separate piece of code.
> 
> PAT patches in x86.git latest, only support some intel CPUs.
> 
>         if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
>             (boot_cpu_data.x86 == 0xF ||
>              (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model >= 15))) {
>                 if (cpu_has_pat) {
>                         return 1;
>                 }
>         }
> 
> should be moved to setup_64.c?
> 

Yes, which in turn should be merged with the 32-bit code in cpu/*.c.

Personally I would prefer a blacklist rather than a whitelist, but 
that's nitpicking.

	-=hpa
