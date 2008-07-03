Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYGCTDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYGCTDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYGCTD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:03:29 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:45720 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYGCTD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:03:27 -0400
Date: Thu, 3 Jul 2008 21:03:07 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       apw@shadowen.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUILD-FAILURE] 2.6.26-rc8-mm1 - x86 -
	__ptep_modify_prot_start() missing
Message-ID: <20080703190307.GA4972@osiris.boeblingen.de.ibm.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org> <20080703122943.GB6451@linux.vnet.ibm.com> <20080703104643.04ea2acb.akpm@linux-foundation.org> <486D13C3.3000409@goop.org> <20080703111418.19f568ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703111418.19f568ca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 11:14:18AM -0700, Andrew Morton wrote:
> On Thu, 03 Jul 2008 11:00:35 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > >> make[1]: *** [arch/x86/kernel/paravirt.o] Error 1
> > >> make: *** [arch/x86/kernel] Error 2
> > >>
> > >> linux-next patches has the changes to the adds the function
> > >> __ptep_modify_prot_start as inline, the patch s390-build-fixes.patch
> > >> is coverting it into macro. Reverting the s390-build-fixes.patch
> > >> fixes the build failure.
> > >>     
> > >
> > > grump.  Who did all this stuff?
> > >
> > > I dunno.  I'll drop s390-build-fixes.patch, add some ccs and stomp off.
> > >
> > >
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > >
> > > In file included from include/asm/pgtable.h:1087,
> > >                  from include/linux/mm.h:39,
> > >                  from arch/s390/mm/hugetlbpage.c:8:
> > > include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
> > > include/asm-generic/pgtable.h:209: error: dereferencing pointer to incomplete type
> > >   
> > 
> > We can't turn them into macros because we're expecting to be able to 
> > take the address of __ptep_modify_prot_start/commit.  What type is not 
> > defined on s390 at that point?  Would simply adding an extra include to 
> > arch/s390/mm/hugetlbpage.c fix the problem?

We need struct task_struct... I added an include <linux/sched.h> to
asm-s390/pgtable.h and it seems to fix the build problem.
I expected include dependency hell...

> > In the worst case we could push __ptep_modify_proc_start/commit out of 
> > line somewhere appropriate, but that's a bit sad given how simple they are.
> 
> I think the s390 guys just fixed the original build error.

Not this one, but if it works I'm going to push that to git-s390.
Currently wading through the s390 build bugs in linux-next and trying to
fix them all :/
