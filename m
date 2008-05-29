Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbYE2ESr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbYE2ESr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYE2ESi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:18:38 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:21955 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709AbYE2ESh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:18:37 -0400
Date: Thu, 29 May 2008 13:16:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] make page-aligned data and bss less fragile
Message-ID: <20080529041631.GA12619@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
References: <483D8292.40808@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483D8292.40808@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 05:04:34PM +0100, Jeremy Fitzhardinge wrote:
> Making a variable page-aligned by using
> __attribute__((section(".data.page_aligned"))) is fragile because if
> sizeof(variable) is not also a multiple of page size, it leaves
> variables in the remainder of the section unaligned.
> 
> This patch introduces two new qualifiers, __page_aligned_data and
> __page_aligned_bss to set the section *and* the alignment of
> variables.  This makes page-aligned variables more robust because the
> linker will make sure they're aligned properly.  Unfortunately it
> requires *all* page-aligned data to use these macros...
> 
> It also updates arch/x86's use of page-aligned variables, since its
> the heaviest user of them in the kernel.  The change to
> arch/x86/xen/mmu.c fixes an actual bug, but the rest are cleanups
> and to set a precident.
> 
> [ I don't know if this would be easier to manage by splitting the
>  x86 part out from the common part. Two following patches apply to
>  powerpc and sh; they're purely decorative. ]
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Paul Mackerras <paulus@samba.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
