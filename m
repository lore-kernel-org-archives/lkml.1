Return-Path: <linux-kernel-owner+w=401wt.eu-S932322AbZKMWsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbZKMWsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932182AbZKMWs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:48:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbZKMWs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:48:27 -0500
Date: Fri, 13 Nov 2009 23:48:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: d451564 breakage
Message-ID: <20091113224820.GB29657@elte.hu>
References: <20091113151119.GA27752@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113151119.GA27752@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russell King <rmk@arm.linux.org.uk> wrote:

> Change:
> 
> highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
> 
> Appears to break ARM:
> 
> mm/highmem.c: In function ???debug_kmap_atomic???:
> mm/highmem.c:436: error: ???KM_NMI??? undeclared (first use in this function)

indeed - sorry.

Note that debug_kmap_atomic() will be removed in v2.6.33 so i'd suggest 
to just do the easy solution and add #ifndef dummy definitions to 
mm/highmem.c to cover ARM - we'll remove the whole cruft for good.

Btw., testing sidenote: i test the ARM defconfig and it didnt break 
there. Perhaps highmem is off in the ARM defconfig? It would be helpful 
if the ARM defconfig enabled highmem.

Thanks,

	Ingo
