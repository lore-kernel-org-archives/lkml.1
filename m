Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbZEKWSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbZEKWSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758992AbZEKWR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:17:57 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:50632 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbZEKWR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:17:56 -0400
Message-ID: <4A08A411.9060104@codemonkey.ws>
Date: Mon, 11 May 2009 17:17:53 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Hollis Blanchard <hollisb@us.ibm.com>
CC: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: PowerPC page faults
References: <20090505132005.19891.78436.stgit@dev.haskins.net>	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>	 <4A0570B1.30401@novell.com>  <4A071F1A.1090702@codemonkey.ws>	 <1242060260.29194.19.camel@slate.austin.ibm.com>	 <4A08663D.1010703@codemonkey.ws> <1242069898.29194.99.camel@slate.austin.ibm.com>
In-Reply-To: <1242069898.29194.99.camel@slate.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hollis Blanchard wrote:
> On Mon, 2009-05-11 at 12:54 -0500, Anthony Liguori wrote:
>   
>> For future ppcemb's, do you know if there is an equivalent of a PF exit 
>> type?  Does the hardware squirrel away the faulting address somewhere 
>> and set PC to the start of the instruction?  If so, no guest memory load 
>> should be required.
>>     
>
> Ahhh... you're saying that the address itself (or offset within a page)
> is the hypercall token, totally separate from IO emulation, and so we
> could ignore the access size.

No, I'm not being nearly that clever.

I was suggesting that hardware virtualization support in future PPC 
systems might contain a mechanism to intercept a guest-mode TLB miss.  
If it did, it would be useful if that guest-mode TLB miss "exit" 
contained extra information somewhere that included the PC of the 
faulting instruction, the address response for the fault, and enough 
information to handle the fault without instruction decoding.

I assume all MMIO comes from the same set of instructions in PPC?  
Something like ld/st instructions?  Presumably all you need to know from 
instruction decoding is the destination register and whether it was a 
read or write?

Or am I oversimplifying?  Does the current hardware spec contain this 
sort of assistance?

Regards,

Anthony Liguori

