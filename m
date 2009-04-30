Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZD3Iem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZD3Iem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZD3IeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:34:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZD3IeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:34:23 -0400
Date: Thu, 30 Apr 2009 10:34:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/21] amd64_edac: add DRAM error injection logic using
	sysfs
Message-ID: <20090430083411.GC21699@elte.hu>
References: <20977.9082.qm@web50109.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20977.9082.qm@web50109.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Doug Thompson <norsk5@yahoo.com> wrote:

> 
> I believe I failed to reply to ALL and replied only to the sender
> 
> doug t
> 
> --- On Wed, 4/29/09, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Subject: Re: [PATCH 20/21] amd64_edac: add DRAM error injection logic using sysfs
> > To: "Borislav Petkov" <borislav.petkov@amd.com>
> > Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> > Date: Wednesday, April 29, 2009, 12:17 PM
> > 
> > * Borislav Petkov <borislav.petkov@amd.com>
> > wrote:
> > 
> > > From: Doug Thompson <dougthompson@xmission.com>
> > > 
> > > Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> > > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > > ---
> > >  drivers/edac/amd64_edac.c |  287
> > +++++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 287 insertions(+), 0
> > deletions(-)
> > > 
> > > diff --git a/drivers/edac/amd64_edac.c
> > b/drivers/edac/amd64_edac.c
> > > index b1a7e8c..4d1076f 100644
> > > --- a/drivers/edac/amd64_edac.c
> > > +++ b/drivers/edac/amd64_edac.c
> > > @@ -4621,3 +4621,290 @@ static ssize_t
> > amd64_hole_show(struct mem_ctl_info *mci, char *data)
> > >  
> > >  #endif    /* DEBUG */
> > >  
> > > +#ifdef CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION
> > 
> > this should be in a separate .c file under
> > drivers/edac/amd64/. 
> > 
> > Introducing large #ifdef sections like that is not very
> > clean. The 
> > amd64_edac.c file is _way_ too large at more than 5000
> > lines of 
> > code.
> > 
> >     Ingo
> 
> If we broke this into a separate files, then there would be TWO 
> (2) files: 1 for the source code of the routines and a 1 for the 
> table entries which reference those routines. Is that then 
> acceptable as well?
> 
> Same pattern applies to the DEBUG functions Info refers to in 
> another thread: 2 separate files would be required as well.
> 
> 2 files for Error Injection code
> 2 files for DEBUG controls
> 1 files for text mapping
> 
> and I assume all these would be included via an #include statement 
> at their appropriate locations

A Makefile might be more natural i think - that way the #ifdef turns 
into a makefile rule?

	Ingo
