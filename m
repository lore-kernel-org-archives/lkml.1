Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbYJTHPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbYJTHPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYJTHO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:14:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53698 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYJTHO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:14:58 -0400
Date: Mon, 20 Oct 2008 09:14:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kdump: Fix invalid access on i386 sparsemem.
Message-ID: <20081020071433.GC12131@elte.hu>
References: <48FC0E68.50902@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FC0E68.50902@mxs.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0020]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp> wrote:

> 
> Hi,
> 
> Since linux-2.6.27, kdump has failed on i386 sparsemem kernel.
> 1st-kernel gets a panic just before switching to 2nd-kernel.
> 
> The cause is that a kernel accesses invalid mem_section by
> page_to_pfn(image->swap_page) at machine_kexec().
> image->swap_page is allocated if kexec for hibernation, but
> it is not allocated if kdump. So if kdump, a kernel should
> not access the mem_section corresponding to image->swap_page.
> The attached patch fixes this invalid access.

applied to tip/x86/urgent, thanks!

	Ingo
