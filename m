Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbXGRLGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbXGRLGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbXGRLGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:06:32 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:45006 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756526AbXGRLGb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:06:31 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 0/2] faking and fixing the NUMA SLIT
Date: Wed, 18 Jul 2007 11:57:28 +0200
User-Agent: KMail/1.9.7
cc: "lkml List" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       lenb@kernel.org, "Christoph Lameter" <clameter@sgi.com>
References: <200707181130.01861.joachim.deguara@amd.com>
 <200707181142.20811.ak@suse.de>
In-Reply-To: <200707181142.20811.ak@suse.de>
MIME-Version: 1.0
Message-ID: <200707181157.29052.joachim.deguara@amd.com>
X-OriginalArrivalTime: 18 Jul 2007 11:06:16.0151 (UTC)
 FILETIME=[A91F0E70:01C7C92B]
X-WSS-ID: 6A832BA17CS2748085-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 11:42:20 Andi Kleen wrote:
> On Wednesday 18 July 2007 11:30:01 Joachim Deguara wrote:
> > The problem with NUMA distances in the SLIT is that they are often wrong,
> > oh wait they aren't there at all because the BIOS didn't create a SLIT
> > since Windows does not use it.  If Linux does not find a slit it just
> > says the distance to local=10 and remote=20 according to ACPI spec.  The
> > problem is when we have a 4P system (or larger), there is generally one
> > node where we have two hops and its distance should be >20.
> >
> > Following are patches to first fake the SLIT in the ACPI code and then
> > add ability to write the distances from sysfs.
>
> The main use for the SLIT information are the zone fallback lists in
> the VM. These are created at boot.  If you change the SLIT later these
> won't be regenerated.
>
> The scheduler also uses it for load balancing, but it is much less
> important there than in the VM.

I looked at how node_distance() was called from page_alloc.c and sched.c but I 
overlooked that those results are really only used at init time.  So the 
backing mechanism of patching the SLIT is right but sysfs is way to late for 
those uses and creating a boot option is as you say ugly.  It would be great 
if BIOS just did this for us and correctly but what do you really expect 
that ;)

I would be happy to add it as a boot option if there is any popular support 
for the idea.

-Joachim





