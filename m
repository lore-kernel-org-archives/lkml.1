Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbXFVOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbXFVOip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbXFVOib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:38:31 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:56285 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756914AbXFVOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:38:28 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 22 Jun 2007 16:39:13 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Ravikiran G Thirumalai" <kiran@scalex86.org>, "Andi Kleen" <ak@suse.de>
cc: "Len Brown" <lenb@kernel.org>, "Steven Whitehouse" <swhiteho@redhat.com>,
       "Shai Fultheim" <shai@scalex86.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Message-ID: <20070622143913.GU5193@alberich.amd.com>
References: <20070619225035.GI5193@alberich.amd.com>
 <200706192338.02807.lenb@kernel.org>
 <20070620084911.GO5193@alberich.amd.com>
 <200706200936.31236.lenb@kernel.org> <20070620182548.GA561@localdomain>
 <20070621183615.GI5193@alberich.amd.com>
MIME-Version: 1.0
In-Reply-To: <20070621183615.GI5193@alberich.amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jun 2007 14:38:04.0870 (UTC)
 FILETIME=[F15E2E60:01C7B4DA]
X-WSS-ID: 6A65015A1S41144837-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 08:36:15PM +0200, Andreas Herrmann wrote:
> On Wed, Jun 20, 2007 at 11:25:48AM -0700, Ravikiran G Thirumalai wrote:
> > On Wed, Jun 20, 2007 at 09:36:30AM -0400, Len Brown wrote:
> > > 
      <snip>

> > > The underlying problem is that Kconfig doesn't support using select
> > > on targets which themselves have dependencies.
> > > 
> > > Signed-off-by: Len Brown <len.brown@intel.com>
> > > 
> > > 
> > > diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> > > index 5ce9443..e9d7767 100644
> > > --- a/arch/x86_64/Kconfig
> > > +++ b/arch/x86_64/Kconfig
> > > @@ -364,9 +364,9 @@ config NODES_SHIFT
> > >  config X86_64_ACPI_NUMA
> > >         bool "ACPI NUMA detection"
> > >         depends on NUMA
> > > -       select ACPI 
> > > +       depends on ACPI 
> > >  	select PCI
> > > -       select ACPI_NUMA
> > > +       depends on ACPI_NUMA
> > >         default y
> > >         help
> > >  	 Enable ACPI SRAT based node topology detection.
> > > -
> > 
      <snip>
> > 
> > 
> > Paper over 'select' inadequacies.  
> > 
> > Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> > 
> > Index: linux-2.6.22-rc5/arch/x86_64/Kconfig
> > ===================================================================
> > --- linux-2.6.22-rc5.orig/arch/x86_64/Kconfig	2007-06-18 16:02:19.571323415 -0700
> > +++ linux-2.6.22-rc5/arch/x86_64/Kconfig	2007-06-20 11:34:29.845354250 -0700
> > @@ -366,6 +366,7 @@ config X86_64_ACPI_NUMA
> >         depends on NUMA
> >         select ACPI 
> >  	select PCI
> > +  	select PM
> >         select ACPI_NUMA
> >         default y
> >         help
> 
> Yep, this one-liner solves all acpi related compile errors/warnings
> that I've reported.
> 
> Additional it resolves anoter problem that results from
> dependencies between CONFIG_PNP and CONFIG_ACPI.
> 


Andi,

are you going to apply Ravikiran's patch?


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



