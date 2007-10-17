Return-Path: <linux-kernel-owner+w=401wt.eu-S1765759AbXJQKlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765759AbXJQKlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbXJQKla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:41:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbXJQKl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:41:29 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: =?iso-8859-1?q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Subject: Re: arcmsr changelog differs from diffs
Date: Wed, 17 Oct 2007 12:41:11 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       James.Bottomley@steeleye.com, nick.cheng@areca.com.tw
References: <200710170007.20454.hpj@urpla.net> <20071017005342.GA14212@atjola.homenet>
In-Reply-To: <20071017005342.GA14212@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710171241.12575.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/feMByr9bsDcBosI/oTV7Tcx3OMZrsK3cPVFS
 nW1YktkbXDsjWbG82Q7LYBkuEglWdfd9zgpZfhbkeuz44WO+xV
 sKLFzwa32Zl/q5M+lrhkw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Björn,

Am Mittwoch, 17. Oktober 2007 02:53 schrieb Björn Steinbrink:
> On 2007.10.17 00:07:19 +0200, Hans-Peter Jansen wrote:
> > Hi Jeff,
> >
> > while browsing through Linus' current check ins, I stumbled upon:
> >
> > [SCSI] arcmsr: irq handler fixes, cleanups, micro-opts:
> >
> > --8<--
> > 488a5c8a9a3b67ae117784cd0d73bef53a73d57d
> >  drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
> > b/drivers/scsi/arcmsr/arcmsr_hba.c
> > index 7832a10..f4d2d52 100644
> > --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> > +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> > @@ -422,7 +422,7 @@ static int arcmsr_probe(struct pci_dev *pdev,
> >  		goto out_release_regions;
> >
> >  	error = request_irq(pdev->irq, arcmsr_do_interrupt,
> > -				IRQF_SHARED, "arcmsr", acb);
> > +			    IRQF_SHARED, "arcmsr", acb);
> >  	if (error)
> >  		goto out_free_ccb_pool;
> >
> > -->8--
> >
> > and: [SCSI] arcmsr: Fix hardware wait loops
> >
> > --8<--
> > 24430458bb924e371ff894e26bfa9f73707f53fb
> >  drivers/scsi/arcmsr/arcmsr_hba.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
> > b/drivers/scsi/arcmsr/arcmsr_hba.c
> > index 50e1310..7832a10 100644
> > --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> > +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> > @@ -2092,8 +2092,10 @@ static void arcmsr_iop_reset(struct
> > AdapterControlBlock *acb)
> >  	if (atomic_read(&acb->ccboutstandingcount) != 0) {
> >  		/* talk to iop 331 outstanding command aborted */
> >  		arcmsr_abort_allcmd(acb);
> > +
> >  		/* wait for 3 sec for all command aborted*/
> >  		ssleep(3);
> > +
> >  		/* disable all outbound interrupt */
> >  		intmask_org = arcmsr_disable_outbound_ints(acb);
> >  		/* clear all outbound posted Q */
> > -->8--
> >
> > where both changelogs differ significantly from the actual diffs, which
> > both are simple WS fixups and nothing else. Does qgit fools me here, or
> > is anything else wrong on my side?
>
> Nothing wrong on your side. I took a look at the second one, and
> everything but the whitespace changes already found its way into Linus'
> tree via 1a4f550a09f89e3a15eff1971bc9db977571b9f6. One hunk of the
> original patch[1] was actually made redundant because the code was
> removed in that commit, so that's probably what James fixed (see full
> commit message).

Yup, I found the patch you mentioned also, but that time orginating from 
Nick Cheng (*).

That diff is unfortunately way too big for me to be able to decide, if it's 
worth it to replace a former instance of arcmsr-1.20.0.13 for a 2.6.18.8 
kernel, which I use and essentially depend on here.

Thus I decided now to bluntly cc Nick and ask directly this way:
Nick, does 1.20.0.15 provide any essential changes over 1.20.0.13 for a 
ARC-1130 with FW 1.41 (2006-05-24), which advise updating?

> And then, if I may guess, James probably just noticed that there were
> changes left and commited them (while they were now down to just the
> whitespace change), without checking what changes were actually left (no
> offense intended). At least I think that git wouldn't cripple the diff
> if the changes that James checked in were not already whitespace-only at
> the time he commited them, and the git history of his tree seems to
> agree.

(*) Thanks for the clarification, Björn. What made me stumbling was the 
different orginators, while Jeff isn't known with catching attention by 
assimilating other peoples contributions. 

> Probably the other commit is similar.
>
> Björn
>
> [1] http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-07/msg11957.html

Pete
