Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYFQQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYFQQSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYFQQSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:18:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:9120 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYFQQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fnaNWvM3JRyCqmAtLngAvUYzY/DXw6gzVmSbBpglOQdmZpH1D7/sXLjLWDlP2gaYQS
         hZpbaZ1MBI6VyLQOotdoTg26ZhyBTDOBWbK0F0SOMSXU9mW6Wi7WVNrHPsjKdZBn0FYc
         Jdgoo6NfM5kH+xIdCVZT4m5crnLI96Dr++kqY=
Message-ID: <86802c440806170918l1cb10014nccfd8d3e2b13da47@mail.gmail.com>
Date: Tue, 17 Jun 2008 09:18:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: merge setup_memory_map with e820
Cc: "Glauber Costa" <glommer@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4857E07F.3070209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806161303.31997.yhlu.kernel@gmail.com>
	 <200806161958.28627.yhlu.kernel@gmail.com>
	 <5d6222a80806170531g50a72ea2r963bba8e404e619f@mail.gmail.com>
	 <4857E07F.3070209@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 9:04 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Glauber Costa wrote:
>>>
>>> +       boot_params.e820_entries = new_nr;
>>> +       if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
>>> < 0) {
>>> +#ifdef CONFIG_X86_64
>>> +               early_panic("Cannot find a valid memory map");
>>> +#else
>>
>> Can't this be made dependant on HIGHMEM instead of X86_64? It seems
>> high-memory dependant anyway. Also, are you sure
>> this code that maps into himem would work with HIGHMEM disabled anyway?

that is behavoir before merge.

>>
>
> Uhm... x86-64 and HIGHMEM are mutually exclusive.
>
> Either way, it shouldn't be dependent on anything; there is no reason why
> the #else clause can't be applied to both.

remove the early_panic?

YH
