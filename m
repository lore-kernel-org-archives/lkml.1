Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZEKRyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZEKRyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbZEKRyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:54:11 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:55883 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbZEKRyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:54:10 -0400
Message-ID: <4A08663D.1010703@codemonkey.ws>
Date: Mon, 11 May 2009 12:54:05 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Hollis Blanchard <hollisb@us.ibm.com>
CC: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net>	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>	 <4A0570B1.30401@novell.com>  <4A071F1A.1090702@codemonkey.ws> <1242060260.29194.19.camel@slate.austin.ibm.com>
In-Reply-To: <1242060260.29194.19.camel@slate.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hollis Blanchard wrote:
> On Sun, 2009-05-10 at 13:38 -0500, Anthony Liguori wrote:
>   
>> Gregory Haskins wrote:
>>     
>>> Can you back up your claim that PPC has no difference in performance
>>> with an MMIO exit and a "hypercall" (yes, I understand PPC has no "VT"
>>> like instructions, but clearly there are ways to cause a trap, so
>>> presumably we can measure the difference between a PF exit and something
>>> more explicit).
>>>       
>> First, the PPC that KVM supports performs very poorly relatively 
>> speaking because it receives no hardware assistance  this is not the 
>> right place to focus wrt optimizations.
>>
>> And because there's no hardware assistance, there simply isn't a 
>> hypercall instruction.  Are PFs the fastest type of exits?  Probably not 
>> but I honestly have no idea.  I'm sure Hollis does though.
>>     
>
> Memory load from the guest context (for instruction decoding) is a
> *very* poorly performing path on most PowerPC, even considering server
> PowerPC with hardware virtualization support. No, I don't have any data
> for you, but switching the hardware MMU contexts requires some
> heavyweight synchronization instructions.
>   

For current ppcemb, you would have to do a memory load no matter what, 
right?  I guess you could have a dedicated interrupt vector or something...

For future ppcemb's, do you know if there is an equivalent of a PF exit 
type?  Does the hardware squirrel away the faulting address somewhere 
and set PC to the start of the instruction?  If so, no guest memory load 
should be required.

Regards,

Anthony Liguori
