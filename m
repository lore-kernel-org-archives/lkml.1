Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbXK1XpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbXK1XpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXK1XpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:45:05 -0500
Received: from gw.goop.org ([64.81.55.164]:45607 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbXK1XpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:45:04 -0500
Message-ID: <474DFD7E.907@goop.org>
Date: Wed, 28 Nov 2007 15:45:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com> <200711291017.52727.rusty@rustcorp.com.au>
In-Reply-To: <200711291017.52727.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 29 November 2007 05:51:29 Christoph Lameter wrote:
>   
>> On Wed, 28 Nov 2007, Rusty Russell wrote:
>>     
>>> On Wednesday 28 November 2007 05:14:47 Christoph Lameter wrote:
>>>       
>>>> On Tue, 27 Nov 2007, Rusty Russell wrote:
>>>>         
>>>>> Have you considered moving x86-64's setup_per_cpu_areas into generic
>>>>> code? It's a bit messier because some archs might not have set up
>>>>> NUMA stuff yet, but it's logically generic...
>>>>>           
>>>> Yes that will happen later. This is just the early cleanup work. I
>>>> plan to generally bring the two x86 arches in line. The pda will be
>>>> folded into the per cpu area and after that its easy to do.
>>>>         
>>> Unfortunately, we tried to get rid of the x86-64 pda (like i386) but you
>>> lose the ability to use the stack protection config option.  That's
>>> because it assumes that gs:0x68 (or something) is the stack canary; we
>>> need a YA gcc change to make this gs:__builtin_stack_canary_off (where
>>> gcc can emit __builtin_stack_canary_off as a weak absolute symbol, so we
>>> can override it for the kernel.
>>>       
>> This works if you rebase the per cpu area at zero. gs:0x68 is still the
>> stack canary.
>>
>> The i386 method does not work because the segment register does not
>> directly point to the pda.
>>     
>
> But the PDA itself is silly (Jeremy ported it to i386 and I balked).  We have 
> a generic one: it's called the per-cpu data.  Having a completely separate 
> per-cpu structure for x86-64 is a mistake.
>   

Yes, I would like to convert x86_64 to match i386's percpu, and drop the
pda altogether.  The only thing preventing this is the stack canary, and
I'm wondering how much value there is in keeping it, given the
disadvantages of having this divergence between 32 and 64 bit.

    J
