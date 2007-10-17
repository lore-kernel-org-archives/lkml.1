Return-Path: <linux-kernel-owner+w=401wt.eu-S935577AbXJQAxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935577AbXJQAxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761546AbXJQAxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:53:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:58538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751250AbXJQAxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:53:46 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+2tfBTIt22jSYUyPig/A20FcaaJVBfERgHAKSuTJ
	po2Nqd0TEJmV4Z
Date: Wed, 17 Oct 2007 02:53:42 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com
Subject: Re: arcmsr changelog differs from diffs
Message-ID: <20071017005342.GA14212@atjola.homenet>
References: <200710170007.20454.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710170007.20454.hpj@urpla.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.10.17 00:07:19 +0200, Hans-Peter Jansen wrote:
> Hi Jeff,
> 
> while browsing through Linus' current check ins, I stumbled upon:
> 
> [SCSI] arcmsr: irq handler fixes, cleanups, micro-opts:
> 
> --8<--
> 488a5c8a9a3b67ae117784cd0d73bef53a73d57d
>  drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c 
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 7832a10..f4d2d52 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -422,7 +422,7 @@ static int arcmsr_probe(struct pci_dev *pdev,
>  		goto out_release_regions;
>  
>  	error = request_irq(pdev->irq, arcmsr_do_interrupt,
> -				IRQF_SHARED, "arcmsr", acb);
> +			    IRQF_SHARED, "arcmsr", acb);
>  	if (error)
>  		goto out_free_ccb_pool;
>  
> -->8--
> 
> and: [SCSI] arcmsr: Fix hardware wait loops
> 
> --8<--
> 24430458bb924e371ff894e26bfa9f73707f53fb
>  drivers/scsi/arcmsr/arcmsr_hba.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c 
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 50e1310..7832a10 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -2092,8 +2092,10 @@ static void arcmsr_iop_reset(struct 
> AdapterControlBlock *acb)
>  	if (atomic_read(&acb->ccboutstandingcount) != 0) {
>  		/* talk to iop 331 outstanding command aborted */
>  		arcmsr_abort_allcmd(acb);
> +
>  		/* wait for 3 sec for all command aborted*/
>  		ssleep(3);
> +
>  		/* disable all outbound interrupt */
>  		intmask_org = arcmsr_disable_outbound_ints(acb);
>  		/* clear all outbound posted Q */
> -->8--
> 
> where both changelogs differ significantly from the actual diffs, which both 
> are simple WS fixups and nothing else. Does qgit fools me here, or is 
> anything else wrong on my side?

Nothing wrong on your side. I took a look at the second one, and
everything but the whitespace changes already found its way into Linus'
tree via 1a4f550a09f89e3a15eff1971bc9db977571b9f6. One hunk of the
original patch[1] was actually made redundant because the code was
removed in that commit, so that's probably what James fixed (see full
commit message).

And then, if I may guess, James probably just noticed that there were
changes left and commited them (while they were now down to just the
whitespace change), without checking what changes were actually left (no
offense intended). At least I think that git wouldn't cripple the diff
if the changes that James checked in were not already whitespace-only at
the time he commited them, and the git history of his tree seems to
agree.

Probably the other commit is similar.

Björn

[1] http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-07/msg11957.html
