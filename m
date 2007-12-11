Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbXLKIef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbXLKIef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 03:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXLKIe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 03:34:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57256 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbXLKIe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 03:34:27 -0500
Date: Tue, 11 Dec 2007 08:34:13 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 5/4] x86: fix up asm-x86/pgtable*.h formatting
Message-ID: <20071211083413.GA19953@infradead.org>
References: <475DA7C5.70900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475DA7C5.70900@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 12:55:33PM -0800, Jeremy Fitzhardinge wrote:
> +#define set_pte_atomic(pteptr, pteval)		set_pte(pteptr,pteval)
> +#define set_pte_present(mm,addr,ptep,pteval)	set_pte_at(mm,addr,ptep,pteval)
>  
> +#define pte_clear(mm,addr,xp)				\
> +	do {						\
> +		set_pte_at(mm, addr, xp, __pte(0));	\
> +	} while (0)
> +
>  #undef pmd_clear
> +#define pmd_clear(xp)				\
> +	do {					\
> +		set_pmd(xp, __pmd(0));		\
> +	} while (0)

What about turning these into inline functions to get better type
checking?

