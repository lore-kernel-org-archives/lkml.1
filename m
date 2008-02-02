Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbYBBJOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbYBBJOD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763028AbYBBJNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:13:47 -0500
Received: from qb-out-0506.google.com ([72.14.204.239]:13571 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbYBBJNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oJ3nAlWG9Sb5lxJia9He8FzBmWAZjnTyR4LFMcsJEzlZlXRSnsU4GX8/ZXNwBm7g+XzcqCcG07XPmn9NqgjcZPDL/sr0LgtKuB8ne1mARe1YuJ8JO5D9rg5DaP7zgAPuUwvs6sOIlNN6JPXcMN5VnDUw3oUWpVoKcDNknHpnynU=
Subject: Re: [PATCH 1 of 7] x86: convert pgalloc_64.h from macros to inlines
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
In-Reply-To: <0d893168b08e5e0d24c2.1201943113@localhost>
References: <0d893168b08e5e0d24c2.1201943113@localhost>
Content-Type: text/plain
Date: Sat, 02 Feb 2008 01:13:50 -0800
Message-Id: <1201943630.1844.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-02 at 01:05 -0800, Jeremy Fitzhardinge wrote:
>  
> -#define __pte_free_tlb(tlb,pte) tlb_remove_page((tlb),(pte))
> -
> -#define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
> -#define __pud_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
> +extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
> +extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
> +extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);

Small question: the extern isn't necessary in headers, is it preferred
in linux anyway?

Harvey

