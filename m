Return-Path: <linux-kernel-owner+w=401wt.eu-S1760990AbZDQRW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760990AbZDQRW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbZDQRWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:22:21 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:59620 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbZDQRWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:22:20 -0400
X-BigFish: VPS-34(zz542N1432R98dR1805M936fK9371Pzz1202hzzz2dh6bh14bh95p61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
Date: Fri, 17 Apr 2009 10:21:46 -0700
In-Reply-To: <fa686aa40904162352g34ea9492ne4db432fd388941a@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
Thread-Index: Acm/KjFmx8gvBKGaSZCCCpyNhl+qnwAVlZCQ
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu> <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu> <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu> <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu> <a3f7086da43a5d4f994344a07a75568f679095d6.1239874968.git.monstr@monstr.eu> <74602b0d6e166c6a657f3d9b7f6c3890b0783326.1239874968.git.monstr@monstr.eu> <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr388941a@mail.gmail.com>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>,
       "John Williams" <john.williams@petalogix.com>
CC: <linux-kernel@vger.kernel.org>, "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 17 Apr 2009 17:22:15.0528 (UTC) FILETIME=[0D850E80:01C9BF81]
Message-ID: <20090417172216.C55431620052@mail15-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: owner-microblaze-uclinux@itee.uq.edu.au [mailto:owner-microblaze-uclinux@itee.uq.edu.au] On
> Behalf Of Grant Likely
> Sent: Thursday, April 16, 2009 11:52 PM
> To: John Williams
> Cc: microblaze-uclinux@itee.uq.edu.au; linux-kernel@vger.kernel.org; Michal Simek
> Subject: Re: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
> 
> On Thu, Apr 16, 2009 at 11:01 PM, John Williams
> <john.williams@petalogix.com> wrote:
> > On Thu, Apr 16, 2009 at 7:56 PM,  <monstr@monstr.eu> wrote:
> >> From: Michal Simek <monstr@monstr.eu>
> >>
> >> Signed-off-by: Michal Simek <monstr@monstr.eu>
> >
> > ACK from a MicroBlaze perspective, but some other comments below:
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> But I'm not sure who should pick this up.
> 
> >
> > A note more for the Xilinx PPC folks (ie Grant Likely):
> >
> > Shouldn't some of these Kconfig depends for PPC be unified?  We have:
> >
> >>  config XILINX_SYSACE
> >>        tristate "Xilinx SystemACE support"
> >> -       depends on 4xx
> >> +       depends on 4xx || MICROBLAZE
> >
> >>  config XILINX_HWICAP
> >>        tristate "Xilinx HWICAP Support"
> >> -       depends on XILINX_VIRTEX
> >> +       depends on XILINX_VIRTEX || MICROBLAZE
> >
> >
> >>  config GPIO_XILINX
> >>        bool "Xilinx GPIO support"
> >> -       depends on PPC_OF
> >> +       depends on PPC_OF || MICROBLAZE
> >>        help
> >>          Say yes here to support the Xilinx FPGA GPIO device
> >
> > Are these all really different options?  PPC_OF?  XILINX_VIRTEX?  4xx?
> 
> xsysace should just depend on either PPC or OF.  It is applicable to
> more than just virtex/spartan systems (I know of at least one
> non-virtex 440 board with a systemace, hence the 4xx usage), and it is
> conceivable that it would be used on other architectures.
> 
> XILINX_VIRTEX makes some sense for hwicap
> 
> PPC_OF doesn't have any real meaning anymore.  PPC would be better.

I'd like to see a single configuration option that makes all of these drivers available.  That way, any processor system (x86, soft arm core, etc.) could turn those on.. The only thing these drivers *REALLY* depend on is OF...  I've circulated patches to do this several times, although they're probably hopelessly out of date at this point.

Steve

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


