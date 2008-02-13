Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbYBMLbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbYBMLbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbYBMLbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:31:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbYBMLbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:31:15 -0500
Message-ID: <47B2D54F.1000302@suse.de>
Date: Wed, 13 Feb 2008 12:32:31 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, ThomasGleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EFI runtime code mapping enhancement
References: <1202894561.5026.14.camel@caritas-dev.intel.com>
In-Reply-To: <1202894561.5026.14.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch enhances EFI runtime code memory mapping as following:
> 
> - Move __supported_pte_mask & _PAGE_NX checking before invoking
>   runtime_code_page_mkexec(). This makes it possible for compiler to
>   eliminate runtime_code_page_mkexec() on machine without NX support.
> 
> - Use set_memory_x/nx in early_mapping_set_exec(). This eliminates the
>   duplicated implementation.

It's a inefficiency because you split up the 2MB (or 1GB) pages
in the direct mapping, although that is not strictly needed. This
means everybody who happens to use memory in same 2M/1G region
will eat unnecessary TLB misses.

It would be generally better to only execute your code in
ioremap_cache() because that won't affect anybody else.

Eventually set_memory_x() will work correctly for ioremap() too
so that should work then.

-Andi

