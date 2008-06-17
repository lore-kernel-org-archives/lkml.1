Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYFQQEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYFQQEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYFQQEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:04:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55030 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYFQQEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:04:40 -0400
Message-ID: <4857E07F.3070209@zytor.com>
Date: Tue, 17 Jun 2008 09:04:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Glauber Costa <glommer@gmail.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: merge setup_memory_map with e820
References: <200806161303.31997.yhlu.kernel@gmail.com>	 <200806161958.28627.yhlu.kernel@gmail.com> <5d6222a80806170531g50a72ea2r963bba8e404e619f@mail.gmail.com>
In-Reply-To: <5d6222a80806170531g50a72ea2r963bba8e404e619f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
>> +       boot_params.e820_entries = new_nr;
>> +       if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0) {
>> +#ifdef CONFIG_X86_64
>> +               early_panic("Cannot find a valid memory map");
>> +#else
> 
> Can't this be made dependant on HIGHMEM instead of X86_64? It seems
> high-memory dependant anyway. Also, are you sure
> this code that maps into himem would work with HIGHMEM disabled anyway?
> 

Uhm... x86-64 and HIGHMEM are mutually exclusive.

Either way, it shouldn't be dependent on anything; there is no reason 
why the #else clause can't be applied to both.

	-hpa


