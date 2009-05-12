Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZELOvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZELOvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZELOvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:51:04 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52693 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbZELOvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:51:01 -0400
From: Hollis Blanchard <hollisb@us.ibm.com>
Organization: IBM Linux Technology Center
To: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: PowerPC page faults
Date: Tue, 12 May 2009 09:50:56 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.2; x86_64; ; )
Cc: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <1242069898.29194.99.camel@slate.austin.ibm.com> <4A08A411.9060104@codemonkey.ws>
In-Reply-To: <4A08A411.9060104@codemonkey.ws>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905120950.57118.hollisb@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 May 2009 17:17:53 Anthony Liguori wrote:
> Hollis Blanchard wrote:
> > On Mon, 2009-05-11 at 12:54 -0500, Anthony Liguori wrote:
> >   
> >> For future ppcemb's, do you know if there is an equivalent of a PF exit 
> >> type?  Does the hardware squirrel away the faulting address somewhere 
> >> and set PC to the start of the instruction?  If so, no guest memory load 
> >> should be required.
> >>     
> >
> > Ahhh... you're saying that the address itself (or offset within a page)
> > is the hypercall token, totally separate from IO emulation, and so we
> > could ignore the access size.
> 
> No, I'm not being nearly that clever.

I started thinking you weren't, but then I realized you must be working 
several levels above me and just forgot to explain... :)

> I was suggesting that hardware virtualization support in future PPC 
> systems might contain a mechanism to intercept a guest-mode TLB miss.  
> If it did, it would be useful if that guest-mode TLB miss "exit" 
> contained extra information somewhere that included the PC of the 
> faulting instruction, the address response for the fault, and enough 
> information to handle the fault without instruction decoding.
> 
> I assume all MMIO comes from the same set of instructions in PPC?  
> Something like ld/st instructions?  Presumably all you need to know from 
> instruction decoding is the destination register and whether it was a 
> read or write?

In addition to register source/target, we also need to know the access size of 
the memory reference. That information isn't stuffed into registers for us by 
hardware, and it's not in published specifications for future hardware.

Now, if you wanted to define a hypercall as a byte access within a particular 
4K page, where the register source/target is ignored, that could be 
interesting, but I don't know if that's relevant to this "hypercall vs MMIO" 
discussion.

-- 
Hollis Blanchard
IBM Linux Technology Center
