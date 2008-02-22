Return-Path: <linux-kernel-owner+w=401wt.eu-S1765171AbYBVLRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765171AbYBVLRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbYBVLRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:17:33 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:62897 "EHLO
	outbound4-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756174AbYBVLRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:17:31 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWN0LR-04-VDW-01
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Fri, 22 Feb 2008 12:15:18 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: don't print a warning when MTRR are blank and
 running in KVM
Message-ID: <20080222111518.GA6504@amd.com>
References: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com>
 <20080221203748.GA9031@elte.hu> <47BDFBDE.5040102@zytor.com>
 <20080222094513.GA6269@elte.hu> <47BE9CB7.5070609@zytor.com>
 <20080222100044.GA6807@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20080222100044.GA6807@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Feb 2008 11:15:18.0565 (UTC)
 FILETIME=[34E41D50:01C87544]
X-WSS-ID: 6BA071430QK12173640-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:00:44AM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Ingo Molnar wrote:
> >> * H. Peter Anvin <hpa@zytor.com> wrote:
> >>
> >>>> I'm not sure how we could detect pure Qemu instances - perhaps it should 
> >>>> define some special MSR or something?
> >>> Perhaps they should fix the Qemu BIOS to actually simulate working MSRs; 
> >>> if nothing else, they should set up the default MTRR to be cachable.
> >>
> >> btw., should KVM do the same?
> >
> > Yes.  Especially since they share a BIOS.
> 
> ok. Then i guess we should just leave the warning and the backtrace in 
> place until they get a fix done?

No. I don't agree. The MTRRs are set up by the BIOS because it knows the
hardware best (I know this is only true in theory). The OS should
basically trust the BIOS MTRR settings. If the OS can't trust the BIOS,
like on real hardware, the check and the warning is necessary. If the OS
can trust the BIOS, like running in a KVM or QEMU virtual machine, it
should just ignore the case where all MTRRs are blank.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


