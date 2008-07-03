Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYGCSQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYGCSQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYGCSQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:16:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbYGCSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:16:06 -0400
Date: Thu, 3 Jul 2008 11:14:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       apw@shadowen.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUILD-FAILURE] 2.6.26-rc8-mm1 - x86 -
 __ptep_modify_prot_start() missing
Message-Id: <20080703111418.19f568ca.akpm@linux-foundation.org>
In-Reply-To: <486D13C3.3000409@goop.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<20080703122943.GB6451@linux.vnet.ibm.com>
	<20080703104643.04ea2acb.akpm@linux-foundation.org>
	<486D13C3.3000409@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2008 11:00:35 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > On Thu, 3 Jul 2008 17:59:43 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> >
> >   
> >> Hi Andrew,
> >>
> >> 2.6.26-rc8-mm1 kernel build fails on the x86
> >>
> >>   CC      arch/x86/kernel/paravirt.o
> >> arch/x86/kernel/paravirt.c:383: error: _____ptep_modify_prot_start___ undeclared here (not in a function)
> >>     
> 
> Where did all those _____underlines___ come from?

gcc idiocy - emitting non-ascii characters from a programming tool. 
Their survival rate through downstream handling is about 2%.  LANG=C
helps.

> >> make[1]: *** [arch/x86/kernel/paravirt.o] Error 1
> >> make: *** [arch/x86/kernel] Error 2
> >>
> >> linux-next patches has the changes to the adds the function
> >> __ptep_modify_prot_start as inline, the patch s390-build-fixes.patch
> >> is coverting it into macro. Reverting the s390-build-fixes.patch
> >> fixes the build failure.
> >>     
> >
> > grump.  Who did all this stuff?
> >
> > I dunno.  I'll drop s390-build-fixes.patch, add some ccs and stomp off.
> >
> >
> > From: Andrew Morton <akpm@linux-foundation.org>
> >
> > In file included from include/asm/pgtable.h:1087,
> >                  from include/linux/mm.h:39,
> >                  from arch/s390/mm/hugetlbpage.c:8:
> > include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
> > include/asm-generic/pgtable.h:209: error: dereferencing pointer to incomplete type
> >   
> 
> We can't turn them into macros because we're expecting to be able to 
> take the address of __ptep_modify_prot_start/commit.  What type is not 
> defined on s390 at that point?  Would simply adding an extra include to 
> arch/s390/mm/hugetlbpage.c fix the problem?
> 
> In the worst case we could push __ptep_modify_proc_start/commit out of 
> line somewhere appropriate, but that's a bit sad given how simple they are.

I think the s390 guys just fixed the original build error.
