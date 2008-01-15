Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYAOWNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYAOWNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYAOWNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:13:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYAOWNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:13:16 -0500
Date: Tue, 15 Jan 2008 23:12:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: [patch for v2.6.24] fix section mismatch warning in page_alloc.c
Message-ID: <20080115221249.GE2665@elte.hu>
References: <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150103.GA2700@elte.hu> <20080114195950.GA9257@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114195950.GA9257@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> [PATCH] mm: fix section mismatch warning in page_alloc.c
> 
> With CONFIG_HOTPLUG=n and CONFIG_HOTPLUG_CPU=y we saw following 
> warning: WARNING: mm/built-in.o(.text+0x6864): Section mismatch: 
> reference to .init.text: (between 'process_zones' and 
> 'pageset_cpuup_callback')
> 
> The culprint was zone_batchsize() which were annotated __devinit but 
> used from process_zones() which is annotated __cpuinit. 
> zone_batchsize() are used from another function annotated __meminit so 
> the only valid option is to drop the annotation of zone_batchsize() so 
> we know it is always valid to use it.

Andrew: a v2.6.24 mm fix i think.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
