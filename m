Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZFYTZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZFYTZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZFYTZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:25:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:25766 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbZFYTZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:25:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,292,1243839600"; 
   d="scan'208";a="702540024"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Date: Thu, 25 Jun 2009 12:25:33 -0700
Subject: RE: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
 Technology support for Linux - Details
Thread-Topic: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
 Technology support for Linux - Details
Thread-Index: Acn1He1/uebvzuTaTLG3CyoNxh7GiQAqEX9w
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D9A2AAD63B@orsmsx506.amr.corp.intel.com>
References: <4A4024B6.2060600@intel.com>	<20090624201415.GA18291@redhat.com>
	<4A428E9D.7080509@linux.intel.com>
 <20090624235000.1e9f4502@lxorguk.ukuu.org.uk>
In-Reply-To: <20090624235000.1e9f4502@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me try to unify and respond to the couple of branches of this thread:

> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Wednesday, June 24, 2009 3:50 PM
>
> > > "trust us, it's signed by intel" doesn't make me feel more secure.
> >
> > how's that different from your normal bios ?
>
> I've yet to see grub load my bios 8)

and

> From: Dave Jones [mailto:davej@redhat.com]
> Sent: Wednesday, June 24, 2009 1:51 PM
>
> On Wed, Jun 24, 2009 at 01:37:49PM -0700, Arjan van de Ven wrote:
>  > Dave Jones wrote:
>  > > On Mon, Jun 22, 2009 at 05:41:26PM -0700, Joseph Cihula wrote:
>  > >
>  > >  > The Q35_SINIT_17.BIN file is what Intel TXT refers to as an
>  > >  > Authenticated Code Module.  It is specific to the chipset in the system
>  > >  > and can also be found on the Trusted Boot site.  It is a firmware module
>  > >  > digitally signed by Intel that is used as part of the DRTM process to
>  > >  > verify and configure the system.
>  > >
>  > > This seems a little disingenious.  Firmware isn't typically loaded by grub
>  > > into main memory and executed by the host processor.
>  > >
>  > > so, is this all worthless without the binary blob ?
>  > >
>  > > "trust us, it's signed by intel" doesn't make me feel more secure.
>  >
>  > how's that different from your normal bios ?
>
> well..
>
> AFAICS, this code exists solely to enable a binary blob. We don't do that
> for the BIOS.  Even for blobs like ACPI, we at least have documentation on
> the opcodes/data structures.
>
> Also, if they're the same as you claim, why isn't the blob just included as
> part of the BIOS ?

I would actually liken the SINIT AC module more to microcode than to BIOS.  If you look at the Intel(R) TXT measured launch flow (e.g. see http://www.xen.org/files/summit_3/Xen_support_for_LaGrande_Technology.pdf), SINIT is executed by the SENTER microcode and the software that executed the SENTER instruction doesn't get control again until after SINIT finishes executing (and SINIT is executing in a special CPU mode that only microcode can create).

Microcode patches, while not loaded by a bootloader, *are* contained in most OSes (as well as the BIOS).  And the TXT architecture allows for an OEM to include SINIT in the BIOS flash (or a special HDD partition, etc.), but desktop BIOS flash space is usually very constrained and none of the OEMs have chosen to do this.  But even if they had, just like most BIOSes include a microcode patch, there is still value in system software being able to provide an updated version so that users don't have to re-flash their BIOS just to get the new module.

Joe
