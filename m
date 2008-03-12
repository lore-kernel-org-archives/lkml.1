Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbYCLRwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbYCLRwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYCLRwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:52:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58619 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYCLRwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:52:15 -0400
Subject: Re: [patch 10/10] System z large page support.
From: Dave Hansen <haveblue@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Gerald Schaefer <geraldsc@de.ibm.com>
In-Reply-To: <20080312173218.404592017@de.ibm.com>
References: <20080312173155.703966894@de.ibm.com>
	 <20080312173218.404592017@de.ibm.com>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 10:52:12 -0700
Message-Id: <1205344332.9828.92.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-12 at 18:32 +0100, Martin Schwidefsky wrote:
> 
> +pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr)
> +{
> +       pgd_t *pgdp;
> +       pud_t *pudp;
> +       pmd_t *pmdp = NULL;
> +
> +       pgdp = pgd_offset(mm, addr);
> +       pudp = pud_alloc(mm, pgdp, addr);
> +       if (pudp)
> +               pmdp = pmd_alloc(mm, pudp, addr);
> +       return (pte_t *) pmdp;
> +}

That looks pretty generic.  Why can't you share with the version we
already have?

-- Dave

