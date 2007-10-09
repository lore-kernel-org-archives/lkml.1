Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbXJIR2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbXJIR2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXJIR2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:28:06 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:41622 "EHLO
	mail32-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbXJIR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:28:05 -0400
X-Greylist: delayed 1967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2007 13:28:03 EDT
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Tue, 9 Oct 2007 18:54:07 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
cc: "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Egger" <Christoph.Egger@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i386: mce cleanup part1: functional change
Message-ID: <20071009165407.GD13205@amd.com>
References: <11919341961890-git-send-email-joerg.roedel@amd.com>
 <11919341961530-git-send-email-joerg.roedel@amd.com>
 <E1IfHZg-0003dp-FA@flower> <20071009160605.GC13205@amd.com>
 <20071009163230.GC22435@flower.upol.cz>
MIME-Version: 1.0
In-Reply-To: <20071009163230.GC22435@flower.upol.cz>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Oct 2007 16:54:07.0852 (UTC)
 FILETIME=[01E922C0:01C80A95]
X-WSS-ID: 6B156DC51DW1312540-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 06:32:30PM +0200, Oleg Verych wrote:
> On Tue, Oct 09, 2007 at 06:06:05PM +0200, Joerg Roedel wrote:
> > > cpu_has() returns int,
> > > but would it be better to have something like
> > > 
> > >   	if (!mce_disabled &&
> > > 	    !(c->x86_capability & (X86_FEATURE_MCA | X86_FEATURE_MCE)) {
> > > 		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > > 			smp_processor_id());
> > 
> > This looks complicated and is harder to read. Its exactly the purpose of the
> > cpu_has() macro to avoid such constructs.
> 
> It is done via test_bit(), which is designed for IO access with all that
> `const volatile' stuff, 2 x unnecessary, can't be optimized here (IMHO).

This code runs only on bootup and once per cpu. I think readable code
is more important here than make it a few cycles faster.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


