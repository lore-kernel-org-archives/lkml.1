Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYGMRye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYGMRye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGMRyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:54:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37553 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYGMRyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:54:25 -0400
Date: Sun, 13 Jul 2008 19:54:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/15] x86_64: Fold pda into per cpu area
Message-ID: <20080713175408.GA17364@elte.hu>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <20080709165129.610711000@polaris-admin.engr.sgi.com> <m14p6ysol6.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14p6ysol6.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Mike Travis <travis@sgi.com> writes:
> 
> > WARNING: there is still a FIXME in this patch (see arch/x86/kernel/acpi/sleep.c)
> >
> >   * Declare the pda as a per cpu variable.
> >
> >   * Make the x86_64 per cpu area start at zero.
> >
> >   * Relocate the initial pda and per_cpu(gdt_page) in head_64.S for the
> >     boot cpu (0).  For secondary cpus, do_boot_cpu() sets up the correct
> >     initial pda and gdt_page pointer.
> >
> >   * Initialize per_cpu_offset to point to static pda in the per_cpu area
> >     (@ __per_cpu_load).
> >
> >   * After allocation of the per cpu area for the boot cpu (0), reload the
> >     gdt page pointer.
> >
> > Based on linux-2.6.tip/master
> 
> Given that we have not yet understood the weird failure case.  This patch needs
> to be split in two.  
> - make the current per cpu variable section zero based.
> - Move the pda into the per cpu variable section.
> 
> There are too many variables at present the reported failure cases to
> guess what is really going on.
> 
> We can not optimize the per cpu variable accesses until the pda moves
> but we can easily test for linker and tool chain bugs with zero
> based pda segment itself.

agreed, a patch of this gravity and with a diffstat:

 12 files changed, 112 insertions(+), 142 deletions(-)

is indeed too large. Test failures that get bisected to this patch will 
still cause people to guess about which aspect of the large patch caused 
the problem.

	Ingo
