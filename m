Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYF3M01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYF3M01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbYF3M0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:26:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbYF3M0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:26:19 -0400
Date: Mon, 30 Jun 2008 14:25:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 34/34] AMD IOMMU: add documentation for kernel
	parameters
Message-ID: <20080630122548.GD25092@elte.hu>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-35-git-send-email-joerg.roedel@amd.com> <20080630000551E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630000551E.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 26 Jun 2008 21:28:10 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Add documentation for the kernel parameters introduced with this driver.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  Documentation/kernel-parameters.txt |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index e07c432..fc8f936 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -271,6 +271,18 @@ and is between 256 and 4096 characters. It is defined in the file
> >  	aic79xx=	[HW,SCSI]
> >  			See Documentation/scsi/aic79xx.txt.
> >  
> > +	amd_iommu=	[HW,X86-84]
> > +			Pass parameters to the AMD IOMMU driver in the system.
> > +			Possible values are:
> > +			off     - disable the driver for AMD IOMMU
> > +			isolate - enable device isolation (each device, as far
> > +			          as possible, will get its own protection
> > +			          domain)
> > +	amd_iommu_size= [HW,X86-64]
> > +			Define the size of the aperture for the AMD IOMMU
> > +			driver. Possible values are:
> > +			'32M', '64M' (default), '128M', '256M', '512M', '1G'
> > +
> >  	amijoy.map=	[HW,JOY] Amiga joystick support
> >  			Map of devices attached to JOY0DAT and JOY1DAT
> >  			Format: <a>,<b>
> 
> Documentation/x86_64/boot-options.txt would be a better place?
> 
> Probabaly, it would be better to clean up x86_64 IOMMU options.

yeah, agreed. There should be a single set of options that is largely 
transparent to the type of iommu used (for those options which are 
commonly implemented - like iommu_size= and iommu= both are).

That belongs in a followup patchset that is decoupled from this IOMMU 
driver submission and should include all current IOMMU(-ish) drivers. 
(If you'd like to work on that we could try any such patchset in -tip, 
ontop of tip/x86/amd-iommu - to keep integration simple.)

	Ingo
