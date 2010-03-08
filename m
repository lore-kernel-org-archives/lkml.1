Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0CHNDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:03:22 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:58316 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0CHNDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:03:20 -0500
Message-ID: <4B94F594.7050205@in.ibm.com>
Date: Mon, 08 Mar 2010 18:33:16 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>, mhiramat@redhat.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PowerPC] 2.6.33-git11 : Badness at kernel/kprobes.c:264
References: <4B920E06.4060508@in.ibm.com> <20100308101152.GA2557@osiris.boeblingen.de.ibm.com> <20100308120009.GC14199@in.ibm.com>
In-Reply-To: <20100308120009.GC14199@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
>>> 2.6.33-git10(64ba99267...) was OK.
>>>
>>> This WARN_ON was introduced by commit 4610ee1d36...
>>>
>>> kprobes: Introduce generic insn_slot framework
>>>       
>> FWIW, same on s390...
>>     
>
> This patch should fix it:
>
> When freeing the instruction slot, the arithmetic to calculate the index
> of the slot in the page needs to account for the total size of the
> instruction on the various architectures.
>
> Calculate the index correctly when freeing the out-of-line execution slot.
>
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>   
Thanks Ananth. Boots fine on my POWER6 box without any WAR_ON.

Regards
-Sachin

> ---
> Index: linux-8mar/kernel/kprobes.c
> ===================================================================
> --- linux-8mar.orig/kernel/kprobes.c	2010-03-08 17:10:33.000000000 +0530
> +++ linux-8mar/kernel/kprobes.c	2010-03-08 17:12:12.000000000 +0530
> @@ -259,7 +259,8 @@
>  	struct kprobe_insn_page *kip;
>
>  	list_for_each_entry(kip, &c->pages, list) {
> -		long idx = ((long)slot - (long)kip->insns) / c->insn_size;
> +		long idx = ((long)slot - (long)kip->insns) /
> +				(c->insn_size * sizeof(kprobe_opcode_t));
>  		if (idx >= 0 && idx < slots_per_page(c)) {
>  			WARN_ON(kip->slot_used[idx] != SLOT_USED);
>  			if (dirty) {
>
>
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

