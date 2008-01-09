Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYAIBJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYAIBJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYAIBJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:09:05 -0500
Received: from gw.goop.org ([64.81.55.164]:53016 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbYAIBJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:09:02 -0500
Message-ID: <47841E3C.9020106@goop.org>
Date: Tue, 08 Jan 2008 17:07:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu>
In-Reply-To: <20080109005914.GA24228@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> In other words, prot and ref_prot can never be equal, so this path is 
>> always taken, and the other branch which tests pte_huge() is never 
>> run.
>>
>> Andi?  Jan?  Is this code just buggy, or is there something else going 
>> on here?
>>     
>
> this code is plain buggy but fixing it triggered driver bugs in the past 
> so we've been procrastinating it forever ...
>   

What kind of driver bugs?  Do drivers manage to get into the other 
branch of the if()?  If not, can't we just remove it and avoid this 
present problem?

Of course, there are a couple of other places which use naked 
__PAGE_KERNEL_* constants, most significantly in head_64.S's initial 
pagetable setup.  Does that rely _PAGE_GLOBAL not being set?  Also 
early_io_remap().

    J
