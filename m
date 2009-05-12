Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZELFq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZELFq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 01:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZELFqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 01:46:38 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:57047 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbZELFqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 01:46:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: PowerPC page faults
Date: Tue, 12 May 2009 13:46:25 +0800
Message-ID: <0A1FE637C2C7E148B9573BB60CC630E52565C7@zch01exm26.fsl.freescale.net>
In-Reply-To: <4A08A411.9060104@codemonkey.ws>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PowerPC page faults
Thread-Index: AcnShtV9dp5v9rCnRjK9TXlhqltW3wAN5zCg
References: <20090505132005.19891.78436.stgit@dev.haskins.net>	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>	 <4A0570B1.30401@novell.com>  <4A071F1A.1090702@codemonkey.ws>	 <1242060260.29194.19.camel@slate.austin.ibm.com>	 <4A08663D.1010703@codemonkey.ws> <1242069898.29194.99.camel@slate.austin.ibm.com> <4A08A411.9060104@codemonkey.ws>
From: "Liu Yu-B13201" <Yu.Liu@freescale.com>
To: "Anthony Liguori" <anthony@codemonkey.ws>,
       "Hollis Blanchard" <hollisb@us.ibm.com>
Cc: "Gregory Haskins" <ghaskins@novell.com>, "Avi Kivity" <avi@redhat.com>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Gregory Haskins" <gregory.haskins@gmail.com>,
       <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: kvm-owner@vger.kernel.org 
> [mailto:kvm-owner@vger.kernel.org] On Behalf Of Anthony Liguori
> Sent: Tuesday, May 12, 2009 6:18 AM
> To: Hollis Blanchard
> Cc: Gregory Haskins; Avi Kivity; Chris Wright; Gregory 
> Haskins; linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: PowerPC page faults
> 
> Hollis Blanchard wrote:
> > On Mon, 2009-05-11 at 12:54 -0500, Anthony Liguori wrote:
> >   
> >> For future ppcemb's, do you know if there is an equivalent 
> of a PF exit 
> >> type?  Does the hardware squirrel away the faulting 
> address somewhere 
> >> and set PC to the start of the instruction?  If so, no 
> guest memory load 
> >> should be required.
> >>     
> >
> > Ahhh... you're saying that the address itself (or offset 
> within a page)
> > is the hypercall token, totally separate from IO emulation, 
> and so we
> > could ignore the access size.
> 
> No, I'm not being nearly that clever.
> 
> I was suggesting that hardware virtualization support in future PPC 
> systems might contain a mechanism to intercept a guest-mode 
> TLB miss.  
> If it did, it would be useful if that guest-mode TLB miss "exit" 
> contained extra information somewhere that included the PC of the 
> faulting instruction, the address response for the fault, and enough 
> information to handle the fault without instruction decoding.

I don't think this can come true if it is software managed TLB.
For guest will never know the content of its TLB without the help of software.

> 
> I assume all MMIO comes from the same set of instructions in PPC?  
> Something like ld/st instructions?  Presumably all you need 
> to know from 
> instruction decoding is the destination register and whether it was a 
> read or write?

Yes, but more there is a search in guest TLB to see if it is a guest TLB miss currently.
A big overhead, especially for a large TLB without being organized by sth. like rbtree.

