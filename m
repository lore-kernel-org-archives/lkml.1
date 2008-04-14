Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYDNIx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYDNIx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYDNIxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:53:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbYDNIxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:53:22 -0400
Date: Mon, 14 Apr 2008 10:53:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch
	fixes
Message-ID: <20080414085307.GG19865@elte.hu>
References: <48022990.3060104@gmail.com> <20080414072645.GG16163@elte.hu> <20080414084127.GA11372@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414084127.GA11372@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > hm, that's an interesting case: we need those annotations probably 
> > because gcc decided to not inline those functions. (this is possible 
> > via the new CONFIG_OPTIMIZE_INLINING=y option) Sam, what's your take 
> > on that?
> 
> gcc uses different heuristics for inlining between the different 
> versions. Therefore to achieve somehow predictable results I added 
> -fno-inline-functions-called-once when CONFIG_DEBUG_SECTION_MISMATCH 
> is enabled.
> 
> So in the above case for any normal kernel build we would see that gcc 
> inlined the above and everything is fine. But for the 
> CONFIG_DEBUG_SECTION_MISMTCH cases we do not inline and thus we see 
> that we have a section mismatch.

ah, ok. So i guess this will result in a few isolated cases of __init 
annotations added to inline functions - Jacek fixed one such case - but 
it should not result in the general spreading of __init annotations to 
inline functions, correct? (which i was worried about)

	Ingo
