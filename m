Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYG1UKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYG1UKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYG1UJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:09:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40673 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbYG1UJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:09:56 -0400
Subject: Re: [PATCH 1/5 V2] Align stack boundaries based on personality
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric Munson <ebmunson@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <6061445882ce9574999bf343eeb333be02a1afa6.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	 <6061445882ce9574999bf343eeb333be02a1afa6.1216928613.git.ebmunson@us.ibm.com>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 13:09:53 -0700
Message-Id: <1217275793.23502.35.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 12:17 -0700, Eric Munson wrote:
> 
> +static unsigned long personality_page_align(unsigned long addr)
> +{
> +       if (current->personality & HUGETLB_STACK)
> +#ifdef CONFIG_STACK_GROWSUP
> +               return HPAGE_ALIGN(addr);
> +#else
> +               return addr & HPAGE_MASK;
> +#endif
> +
> +       return PAGE_ALIGN(addr);
> +}
...
> -       stack_top = PAGE_ALIGN(stack_top);
> +       stack_top = personality_page_align(stack_top);

Just out of curiosity, why doesn't the existing small-page case seem to
care about the stack growing up/down?  Why do you need to care in the
large page case?

-- Dave

