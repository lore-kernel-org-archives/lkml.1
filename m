Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbYEMPO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbYEMPO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYEMPOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:14:20 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39495 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbYEMPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:14:19 -0400
Date: Tue, 13 May 2008 16:12:10 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Glauber Costa <glommer@gmail.com>
cc: Glauber Costa <gcosta@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix app crashes after SMP resume
In-Reply-To: <5d6222a80805130703n68018048se32e7feadea26dc4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805131556340.28566@blonde.site>
References: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
 <5d6222a80805130703n68018048se32e7feadea26dc4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008, Glauber Costa wrote:
> On Tue, May 13, 2008 at 10:26 AM, Hugh Dickins <hugh@veritas.com> wrote:
> >
> >  +#ifdef CONFIG_X86_32
> >  +       while (low_mappings)
> >  +               cpu_relax();
> >  +       __flush_tlb_all();
> >  +#endif
> >  +
> 
> If possible, we don't want to introduce any more ifdefs. Should be
> better to do it openly, define low_mappings as always 0 for x86_64.

You're right, something like that (but avoiding the __flush_tlb_all
on x86_64) would have been nicer; never mind, now it's going forward,
I'll leave it as is.

A bigger improvement would be to cut out all that swapper_pg_dir
to and fro, needing a global TLB flush on all cpus for each cpu.
Just have an alternate pg_dir (often already there as swsusp_pg_dir)
to point cr3 at for the bootup (or maybe it needs to be vice versa).

But that's harder to get right, and involves wider changes and much
more testing than I could afford for the bugfix.  Plus I expect it's
on your radar if not already done.

Hugh
