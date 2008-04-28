Return-Path: <linux-kernel-owner+w=401wt.eu-S934208AbYD1NIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbYD1NIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbYD1NIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:08:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46932 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765277AbYD1NIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:08:42 -0400
Date: Mon, 28 Apr 2008 15:08:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to
	discrete layout v2
Message-ID: <20080428130826.GH27997@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804280206.52641.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804280206.52641.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> some BIOS like to use continus MTRR layout, and X driver can not add 
> WB entries for graphical cards when 4g or more RAM installed.
> 
> the patch will change MTRR to discrete.
> 
> mtrr_chunk_size= could be used to have smaller continuous block to 
> hold holes. default is 256m, could be set according to size of 
> graphics card memory.

hm.

> +static int disable_mtrr_cleanup;

i think this should be default-disabled. Touching MTRRs on a live system 
could interact with SMM and MCE handlers.

how relevant is this feature with modern Xorg? I thought modern Xorg 
would get its mappings via /sys, hence it would not have to touch MTRRs 
at all.

	Ingo
