Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYAVOdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYAVOdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYAVOdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:33:10 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:40682
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYAVOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:33:09 -0500
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 09:33:09 EST
Message-ID: <4795F9D2.1050503@qumranet.com>
Date: Tue, 22 Jan 2008 16:12:34 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>, clameter@sgi.com
Subject: Re: [kvm-devel] [PATCH] mmu notifiers #v3
References: <20080113162418.GE8736@v2.random>	<20080116124256.44033d48@bree.surriel.com>	<478E4356.7030303@qumranet.com> <20080117162302.GI7170@v2.random>	<478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random>
In-Reply-To: <20080121125204.GJ6970@v2.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -44,8 +44,10 @@
>  ({									\
>  	int __young;							\
>  	__young = ptep_test_and_clear_young(__vma, __address, __ptep);	\
> -	if (__young)							\
> +	if (__young) {							\
>  		flush_tlb_page(__vma, __address);			\
> +		mmu_notifier(age_page, (__vma)->vm_mm, __address);	\
> +	}								\
>  	__young;							\
>  })
>   

I think that unconditionally doing

  __young |= mmu_notifier(test_and_clear_young, ...);

allows hardware with accessed bits more control over what is going on.

-- 
error compiling committee.c: too many arguments to function

