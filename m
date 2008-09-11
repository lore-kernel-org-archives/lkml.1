Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbYIKS5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbYIKS5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYIKS5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:57:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40358 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbYIKS5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:57:07 -0400
Date: Thu, 11 Sep 2008 20:56:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
Message-ID: <20080911185647.GA20188@elte.hu>
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu> <20080910115525.GA31692@elte.hu> <48C7FA91.9050302@goop.org> <20080911073337.GF27877@elte.hu> <48C9653F.1090805@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C9653F.1090805@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > the false positive should be avoided, for example by unmapping the 
> > 'prev' mapping shortly before the leak check.
> >   
> 
> Yep.  I'll make it unmap just before setting acpi_gbl_permanent_mmap,
> which is when it switches to using plain old ioremap.
> 
> >> (All those other backtraces are just informational, right?)
> >>     
> >
> > no, they cause hard failures in my test setup. Nor do we want to litter 
> > the bootup log with messages that are not correct.
> >   
> 
> No, I mean that early_ioremap_debug causes all early_ioremap()s to 
> dump a stack trace, so most of the stack dumps in the boot log are 
> diagnostic/informational rather than indications of lots of problems.

ah - now i understand what you mean, sure. The only non-diagnostic 
message that the test barfed on was the leak warning itself. The others 
were there because i did a second boot with the diagnostic messages 
enabled as well. (so that there's a full track of what is mapped where)

	Ingo
