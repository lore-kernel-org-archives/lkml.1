Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbXKHQnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbXKHQnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbXKHQnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:43:04 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:15218 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbXKHQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:43:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j8yNp8L7gZLPk/ky9jhpPtmFkMD6AvXWptpYyaoIKBKPQOv3Wtl7KCROLcSHQ0cZ0/YYLtQ3aDPzT+SEcsu+zAl53ZXM6R/e0dcoJ2nYiKDZdX54jCfGn8ttzlS1rXK52wxJnlI6Fl1vYus0rmiTvglwnkD/b5cNUEK/NOa8o7E=
Message-ID: <5d6222a80711080842i201cb431le966d5069d59db24@mail.gmail.com>
Date: Thu, 8 Nov 2007 14:42:59 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH RFC 3/7] x86: clean up asm-x86/page*.h
Cc: LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Zach Amsden" <zach@vmware.com>,
       "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <20071108015310.218076184@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071108015008.660012621@goop.org>
	 <20071108015310.218076184@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2007 11:50 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> +#define PAGETABLE_LEVELS       3
> +
> +typedef u64    pteval_t;
> +typedef u64    pmdval_t;
> +typedef u64    pudval_t;
> +typedef u64    pgdval_t;
> +

> -static inline unsigned long long native_pgd_val(pgd_t pgd)
> +static inline pgdval_t native_pgd_val(pgd_t pgd)
>  {
Maybe these kind of things, the typedef and native_xxx definitions can
go into the common header, after we define the PAGETABLE_LEVELS
constant?
I think the more goes into common headers, the better.

> -static inline pte_t native_make_pte(unsigned long long val)
> +static inline pte_t native_make_pte(pteval_t val)
>  {
>         return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
>  }
Although these make_xxx things can probably be just left here...


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
