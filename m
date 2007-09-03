Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbXICJRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbXICJRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 05:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbXICJRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 05:17:41 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:20747 "EHLO
	outbound9-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755724AbXICJRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 05:17:38 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 3 Sep 2007 11:17:18 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Arjan van de Ven" <arjan@infradead.org>
cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070903091718.GB22144@alberich.amd.com>
References: <20070903081736.288288000@amd.com>
 <20070903081736.588599000@amd.com>
 <20070903013157.72c94891@laptopd505.fenrus.org>
MIME-Version: 1.0
In-Reply-To: <20070903013157.72c94891@laptopd505.fenrus.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Sep 2007 09:17:16.0770 (UTC)
 FILETIME=[38C2F420:01C7EE0B]
X-WSS-ID: 6AC50EA91A46456896-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 01:31:57AM -0700, Arjan van de Ven wrote:
> On Mon, 03 Sep 2007 10:17:39 +0200
> "Robert Richter" <robert.richter@amd.com> wrote:
> 
> > This patch implements PCI extended configuration space access for
> > AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
> > addresses. An x86 capability bit has been introduced that is set for
> > CPUs supporting PCI extended config space accesses.
> > 
> 
> 
> No offence but this feels a bit wrong to me.
> 
> PCI is sort of more a chipset property than a cpu property (I realize
> that this boundary is changing of course).
> 
> I'd like to ask you to at least rename some of the feature bits to
> indicate that the extended config space is for the IO access method;
> after all Linux already supports the MMIO method for accessing extended
> config space since a really long time; not marking the feature bit to
> indicate it's the IO method is going to be extremely confusing and
> cause bugs I bet.

Hmm, yes the naming  of the CPU capability bit seems wrong.
Guess, Robert will fix it.

> (we probably need a global function that drivers can use to find out of
> extended config space is accessible; however that for sure isn't a CPU
> capability bit.

IMHO this is already available. Just check pci_dev->cfg_size which
is 256 if PCI ECS access is not possible (see pci_cfg_space_size()).

> However the current naming etc sort of makes me fear
> drivers will abuse this thing while thinking it's the right API)

Do you see any other issues besides the naming of the bit?


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



