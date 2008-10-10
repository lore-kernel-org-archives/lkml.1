Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbYJJLBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbYJJLBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbYJJLA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:00:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60273 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbYJJLA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:00:58 -0400
Date: Fri, 10 Oct 2008 13:00:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] xen: do not reserve 2 pages of padding between
	hypervisor and fixmap.
Message-ID: <20081010110038.GB4699@elte.hu>
References: <1223634458-25820-1-git-send-email-Ian.Campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223634458-25820-1-git-send-email-Ian.Campbell@citrix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Campbell <Ian.Campbell@citrix.com> wrote:

> When reserving space for the hypervisor the Xen paravirt backend adds 
> an extra two pages (this was carried forward from the 2.6.18-xen tree 
> which had them "for safety"). Depending on various CONFIG options this 
> can cause the boot time fixmaps to span multiple PMDs which is not 
> supported and triggers a WARN in early_ioremap_init().
> 
> This was exposed by 2216d199b1430d1c0affb1498a9ebdbd9c0de439 which
> moved the dmi table parsing earlier.
>     x86: fix CONFIG_X86_RESERVE_LOW_64K=y
> 
>     The bad_bios_dmi_table() quirk never triggered because we do DMI setup
>     too late. Move it a bit earlier.
> 
> There is no real reason to reserve these two extra pages and the
> fixmap already incorporates FIX_HOLE which serves the same
> purpose. None of the other callers of reserve_top_address do this.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Signed-off-by: Ingo Molnar <mingo@elte.hu>

applied to tip/x86/xen, thanks Ian!

	Ingo
