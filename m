Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZEKQoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZEKQoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZEKQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:44:28 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57680 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZEKQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:44:27 -0400
Subject: Re: [RFC PATCH 0/3] generic hypercall support
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <4A071F1A.1090702@codemonkey.ws>
References: <20090505132005.19891.78436.stgit@dev.haskins.net>
	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>
	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>
	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>
	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>
	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>
	 <4A0570B1.30401@novell.com>  <4A071F1A.1090702@codemonkey.ws>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 11 May 2009 11:44:20 -0500
Message-Id: <1242060260.29194.19.camel@slate.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 13:38 -0500, Anthony Liguori wrote:
> Gregory Haskins wrote:
> >
> > Can you back up your claim that PPC has no difference in performance
> > with an MMIO exit and a "hypercall" (yes, I understand PPC has no "VT"
> > like instructions, but clearly there are ways to cause a trap, so
> > presumably we can measure the difference between a PF exit and something
> > more explicit).
> 
> First, the PPC that KVM supports performs very poorly relatively 
> speaking because it receives no hardware assistance  this is not the 
> right place to focus wrt optimizations.
> 
> And because there's no hardware assistance, there simply isn't a 
> hypercall instruction.  Are PFs the fastest type of exits?  Probably not 
> but I honestly have no idea.  I'm sure Hollis does though.

Memory load from the guest context (for instruction decoding) is a
*very* poorly performing path on most PowerPC, even considering server
PowerPC with hardware virtualization support. No, I don't have any data
for you, but switching the hardware MMU contexts requires some
heavyweight synchronization instructions.

> Page faults are going to have tremendously different performance 
> characteristics on PPC too because it's a software managed TLB. There's 
> no page table lookup like there is on x86.

To clarify, software-managed TLBs are only found in embedded PowerPC.
Server and classic PowerPC use hash tables, which are a third MMU type.

-- 
Hollis Blanchard
IBM Linux Technology Center

