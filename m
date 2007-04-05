Return-Path: <linux-kernel-owner+w=401wt.eu-S1767313AbXDEVJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767313AbXDEVJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767314AbXDEVJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:09:06 -0400
Received: from gw.goop.org ([64.81.55.164]:42800 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767313AbXDEVJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:09:05 -0400
Message-ID: <46156548.6080102@goop.org>
Date: Thu, 05 Apr 2007 14:08:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What protects cpu_tlbstate?
References: <4615518A.4070003@goop.org> <200704052228.36590.ak@suse.de> <46156366.70206@goop.org> <200704052303.35846.ak@suse.de>
In-Reply-To: <200704052303.35846.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Hm, I was more wondering about simple compiler reordering.  Does the
>> relative order of setting and reading cpu_tlbstate.state, active_mm and
>> the mm->cpu_vm_mask matter?
>>     
>
> Hmm, perhaps a barrier between state and active_mm might be a good idea.
> Setting active_mm after state might be problematic.
> cpu_vm_mask should be already a memory barrier.
>   

Should leave_mm update active_mm and set the state to TLBSTATE_OK?  Just
reloading cr3 seems a bit blunt.

    J
