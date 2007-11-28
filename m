Return-Path: <linux-kernel-owner+w=401wt.eu-S1761706AbXK1RC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706AbXK1RC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbXK1RCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:02:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148AbXK1RCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:02:20 -0500
Date: Wed, 28 Nov 2007 18:02:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128170213.GA23606@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu> <20071128150840.GB5518@c2.user-mode-linux.org> <E1IxOzn-00075w-Gq@dorka.pomaz.szeredi.hu> <20071128154152.GA742@elte.hu> <E1IxPKU-00079S-UH@dorka.pomaz.szeredi.hu> <20071128160501.GA7986@elte.hu> <E1IxQEX-0007Ji-TV@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxQEX-0007Ji-TV@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > so you can define irqs_off_flags to always-0 and you should be able 
> > to get pretty good traces still. It should have no functional 
> > impact.
> 
> OK, managed to make it compile, but then something goes wrong in 
> tracer_alloc_bootmem().

try with a lower MAX_TRACE first - 1 million entries (default) uses up 
like 32 MB of RAM per CPU, that might be quite a bit and your UML image 
might not be able to take that.

also, you can do a s/trace_alloc_bootmem/alloc_bootmem - the 
alloc-bootmem wrapping was only done to get the tracer boot with really 
ridiculously high MAX_TRACE.

	Ingo
