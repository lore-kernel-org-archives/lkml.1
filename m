Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbYBNQs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbYBNQs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYBNQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:48:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38487 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbYBNQsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:48:47 -0500
Date: Thu, 14 Feb 2008 08:47:49 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86: apic: Export symbols for extended interrupt
 LVT functions
Message-ID: <20080214084749.2a936f85@laptopd505.fenrus.org>
In-Reply-To: <20080214094036.GA16892@erda.amd.com>
References: <20080213151811.804698000@amd.com>
	<20080213151841.520543000@amd.com>
	<20080213143256.54e9a3c7@laptopd505.fenrus.org>
	<20080214094036.GA16892@erda.amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 10:40:36 +0100
"Robert Richter" <robert.richter@amd.com> wrote:

> On 13.02.08 14:32:56, Arjan van de Ven wrote:
> > On Wed, 13 Feb 2008 16:19:36 +0100 (CET)
> > "Robert Richter" <robert.richter@amd.com> wrote:
> > 
> > > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > > ---
> > >  arch/x86/kernel/apic_64.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
> > > index d8d03e0..2a9f4bc 100644
> > > --- a/arch/x86/kernel/apic_64.c
> > > +++ b/arch/x86/kernel/apic_64.c
> > > @@ -215,12 +215,14 @@ u8 setup_APIC_eilvt_mce(u8 vector, u8
> > > msg_type, u8 mask) setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE,
> > > vector, msg_type, mask); return APIC_EILVT_LVTOFF_MCE;
> > >  }
> > > +EXPORT_SYMBOL(setup_APIC_eilvt_mce);
> > >  
> > >  u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
> > >  {
> > >  	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type,
> > > mask); return APIC_EILVT_LVTOFF_IBS;
> > >  }
> > > +EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
> > 
> > which modules would even consider using any of these?
> > Doesn't sound like something we should export..
> 
> For IBS it is Perfmon. See here:
> http://git.kernel.org/?p=linux/kernel/git/eranian/linux-2.6.git;a=commit;h=7caef3e19d17349f869884f5adf7c9823e32ade7
> 

perfmon doesn't seem to go anywhere lately, so realistically this chunk should be part of the perfmon tree.

> MCE export has been added for consistency reasons to allow modules to
> enable MCE.

no module does that right now, nor should it. MCE is really something the core kernel should do right?
"consistency reasons" isn't "just export everything used or not", it's "oh this makes sense as part of a well
thought out, generic consistent api". This one isn't./


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
