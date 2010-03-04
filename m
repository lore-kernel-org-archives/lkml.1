Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0CDL3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:29:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:35611 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0CDL3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:29:44 -0500
X-SpamScore: -23
X-BigFish: VPS-23(zz146fK1432R98dN936eMzz1202hzzz32i87h6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYR99B-01-4HB-02
X-M-MSG: 
Date: Thu, 4 Mar 2010 12:29:34 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka
 NPT-Virtualization)
Message-ID: <20100304112934.GL31544@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <1282BA89-D8EB-499B-BC49-E50CA64E408D@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1282BA89-D8EB-499B-BC49-E50CA64E408D@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Mar 2010 11:29:34.0796 (UTC) FILETIME=[F75758C0:01CABB8D]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 12:44:48AM +0100, Alexander Graf wrote:
> 
> On 03.03.2010, at 20:12, Joerg Roedel wrote:
> 
> > Hi,
> > 
> > here are the patches that implement nested paging support for nested
> > svm. They are somewhat intrusive to the soft-mmu so I post them as RFC
> > in the first round to get feedback about the general direction of the
> > changes.  Nevertheless I am proud to report that with these patches the
> > famous kernel-compile benchmark runs only 4% slower in the l2 guest as
> > in the l1 guest when l2 is single-processor. With SMP guests the
> > situation is very different. The more vcpus the guest has the more is
> > the performance drop from l1 to l2. 
> > Anyway, this post is to get feedback about the overall concept of these
> > patches.  Please review and give feedback :-)
> 
> Nice job! It's great to see you finally got around to it :-).
> 
> Have you tracked what slows down SMP l2 guests yet? So far I've been
> assuming that IPIs just completely kill the performance, but I guess
> it shouldn't be that bad, especially now where you have sped up the
> #VMEXIT path that much.

I have not yet looked deeper into this issue. I also suspect lockholder
preemption to be the cause for this. I did the test with a
populated nested page table too and the slowdown is still there. But
thats all guessing, I need to do some research for the exact reasons.

	Joerg


