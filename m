Return-Path: <linux-kernel-owner+w=401wt.eu-S934490AbYD1NOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490AbYD1NOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933901AbYD1NO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:14:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbYD1NO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:14:27 -0400
Date: Mon, 28 Apr 2008 15:14:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 vDSO: use initdata
Message-ID: <20080428131408.GI27997@elte.hu>
References: <20080428014538.DC68926F8F0@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428014538.DC68926F8F0@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Roland McGrath <roland@redhat.com> wrote:

> The 64-bit vDSO image is in a special ".vdso" section for no reason I 
> can determine.  Furthermore, the location of the vdso_end symbol 
> includes some wrongly-calculated padding space in the image, which is 
> then (correctly) rounded to page size, resulting in an extra page of 
> zeros in the image mapped in to user processes.
> 
> This changes it to put the vdso.so image into normal initdata as we 
> have always done for the 32-bit vDSO images.  The extra padding is 
> gone, so the user VMA is one page instead of two.  The image that was 
> already copied around at boot time is now in initdata, so we recover 
> that wasted space after boot.

thanks Roland, applied. I suspect this will need a few days of test-time 
as we change the user-space vma layout. (not in material ways though)

	Ingo
