Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYFBKLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYFBKLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYFBKLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:11:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49212 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYFBKLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:11:21 -0400
Date: Mon, 2 Jun 2008 12:10:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       x86@kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [bisected] Re: [PATCH 05 of 12] xen: add p2m mfn_list_list
Message-ID: <20080602101059.GB7459@elte.hu>
References: <patchbomb.1211550067@localhost> <a405e5f9ddf6f5f142ea.1211550072@localhost> <20080528122813.GA5502@elte.hu> <483D65E6.3020604@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483D65E6.3020604@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Subject: make page-aligned data and bss less fragile
>
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

applied to -tip, thanks Jeremy. Created a new topic branch for the core 
bits of it: tip/build. Sam might want to pull from that topic branch 
eventually, once these changes pass testing in -tip.

	Ingo
