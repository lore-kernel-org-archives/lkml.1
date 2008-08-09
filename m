Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYHIG3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYHIG3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 02:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYHIG3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 02:29:41 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41884 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYHIG3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 02:29:40 -0400
Date: Sat, 9 Aug 2008 16:29:38 +1000
From: Simon Horman <horms@verge.net.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@kernel.org>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel@lists.xensource.com, Eduardo Habkost <ehabkost@redhat.com>,
       Stephen Tweedie <sct@redhat.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: work around gcc 3.4.x bug
Message-ID: <20080809062937.GA5424@verge.net.au>
References: <20080808050429.GA8473@verge.net.au> <489BE9C3.2010006@goop.org> <20080808080155.GA1992@cs181140183.pp.htv.fi> <489C6485.7050009@goop.org> <20080808161331.GF14495@cs181140183.pp.htv.fi> <489C89FA.5000301@goop.org> <20080808183711.GA14495@cs181140183.pp.htv.fi> <489CB08F.9030902@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489CB08F.9030902@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 01:46:07PM -0700, Jeremy Fitzhardinge wrote:
> gcc-3.4.x crashes when compiling pgd_prepopulate_pmd() when
> PREALLOCATED_PMDS == 0 and CONFIG_DEBUG_INFO is enabled.  This seems
> to avoid the problem.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Adrian Bunk <bunk@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Hi Jeremy,

This does solve the problem I was seeing on on 3.4.5.

Acked-by: Simon Horman <horms@verge.net.au>

> ---
> arch/x86/mm/pgtable.c |    3 +++
> 1 file changed, 3 insertions(+)
>
> ===================================================================
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -207,6 +207,9 @@
> 	unsigned long addr;
> 	int i;
>
> +	if (PREALLOCATED_PMDS == 0) /* Work around gcc-3.4.x bug */
> +		return;
> +
> 	pud = pud_offset(pgd, 0);
>
>  	for (addr = i = 0; i < PREALLOCATED_PMDS;
>
