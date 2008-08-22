Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYHVAfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYHVAfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYHVAfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:35:48 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:49372 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753146AbYHVAfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:35:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Vh4rjadWPOTcqAMOUhaETly46mg4Stt+wCBHUiXFnQWM3LG4gYG5csG1GYUZWEiPCLbAkHMbiF/Dkkm6klQVdgXt7o1O9ksJb40MmXnOdVIzxlNO2Omk0Ubbi6zUAzwZ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
Date: Thu, 21 Aug 2008 17:35:26 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
References: <1218854205-2375-1-git-send-email-yhlu.kernel@gmail.com> <200808211607.05811.jbarnes@virtuousgeek.org> <m1ej4hnc2n.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ej4hnc2n.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211735.26655.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2008 5:11 pm Eric W. Biederman wrote:
> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> > On Thursday, August 21, 2008 1:47 pm Eric W. Biederman wrote:
> >> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> >> > On Friday, August 15, 2008 7:36 pm Yinghai Lu wrote:
> >> >> we are using 28bit pci (bus/dev/fn + 12 bits) as irq number, so the
> >> >> cache for irq number should be 32 bit too.
> >> >>
> >> >> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >> >> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> >> >>
> >> >> ---
> >> >>  drivers/scsi/qla2xxx/qla_def.h |    2 +-
> >> >>  include/linux/pci.h            |    2 +-
> >> >>  2 files changed, 2 insertions(+), 2 deletions(-)
> >> >>
> >> >> Index: linux-2.6/drivers/scsi/qla2xxx/qla_def.h
> >> >> ===================================================================
> >> >> --- linux-2.6.orig/drivers/scsi/qla2xxx/qla_def.h
> >> >> +++ linux-2.6/drivers/scsi/qla2xxx/qla_def.h
> >> >> @@ -2109,7 +2109,7 @@ struct scsi_qla_host;
> >> >>
> >> >>  struct qla_msix_entry {
> >> >>  	int have_irq;
> >> >> -	uint16_t msix_vector;
> >> >> +	uint32_t msix_vector;
> >> >>  	uint16_t msix_entry;
> >> >>  };
> >> >>
> >> >> Index: linux-2.6/include/linux/pci.h
> >> >> ===================================================================
> >> >> --- linux-2.6.orig/include/linux/pci.h
> >> >> +++ linux-2.6/include/linux/pci.h
> >> >> @@ -730,7 +730,7 @@ enum pci_dma_burst_strategy {
> >> >>  };
> >> >>
> >> >>  struct msix_entry {
> >> >> -	u16 	vector;	/* kernel uses to write allocated vector */
> >> >> +	u32	vector;	/* kernel uses to write allocated vector */
> >> >>  	u16	entry;	/* driver uses to specify entry, OS writes */
> >> >>  };
> >> >
> >> > I see a lot of smoke about this, but not a clear consensus.  It sounds
> >> > like no one objects to making the MSI vector field 32 bits, but there
> >> > were a lot of concerns about IRQ vector naming/numbering in general? 
> >> > And I assume this particular patch isn't 2.6.27 material...
> >>
> >> There is no need for this particular patch in 2.6.27.
> >> It is a trivial bug fix so it can go in whenever.
> >>
> >> Mostly this is a discussion about code that should land in the 2.6.28
> >> timeframe assuming all is well.
> >
> > Ok, thanks Eric.  I'll queue it up for linux-next after the next 2.6.27
> > pull.
>
> Are you maintaining the pci tree now?  I get lost who is doing what some
> days.

Yep, since af40b485ea2d957ae2f237ab0e33539ae8f29562.

-- 
Jesse Barnes, Intel Open Source Technology Center
