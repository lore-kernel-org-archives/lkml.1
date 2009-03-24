Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbZCXMZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbZCXMZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZCXMZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:25:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbZCXMZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:25:35 -0400
Date: Tue, 24 Mar 2009 13:25:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] perf_counter: fix perf_poll()
Message-ID: <20090324122520.GA17442@elte.hu>
References: <18888.29986.340328.540512@cargo.ozlabs.ibm.com> <1237875063.7530.11.camel@marge.simson.net> <1237875580.7827.3.camel@marge.simson.net> <1237877884.8754.2.camel@marge.simson.net> <18888.38308.223722.602357@cargo.ozlabs.ibm.com> <1237888224.24918.159.camel@twins> <1237891863.13862.27.camel@marge.simson.net> <1237892368.24918.160.camel@twins> <1237897096.24918.181.camel@twins> <1237897279.24918.182.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237897279.24918.182.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-03-24 at 13:18 +0100, Peter Zijlstra wrote:
> > The below does seem to fix things (along with the previous kerneltop.c
> > patch),.. however now kerneltop is going splat like:
> > 
> > # ./kerneltop -e 1:2 -c 10
> > KernelTop refresh period: 2 seconds
> > ret: 1
> >  left: 0000000080200000
> >    ip: 000000008038d4ad
> > right: 00000000ffffffff
> > kerneltop: kerneltop.c:985: record_ip: Assertion `left <= ip && ip <= right' failed.
> > Aborted
> > 
> > Which isn't making much sense..
> 
> Seems to be an artefact of running a 32bit kerneltop on a 64bit 
> kernel.. freshyl compiled 64bit kerneltop works just fine.

Looks like you discovered a real bug by accident :)

	Ingo
