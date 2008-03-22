Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYCVCYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYCVCYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYCVCYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:24:44 -0400
Received: from gw.goop.org ([64.81.55.164]:49452 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYCVCYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:24:43 -0400
Message-ID: <47E46CC7.8080503@goop.org>
Date: Fri, 21 Mar 2008 19:19:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: Re: [patch 2/4] x86: Fix build breakage when PCI is define and PARAVIRT
 is not
References: <20080320073740.GA9414@localdomain> <20080320074116.GC9414@localdomain> <47E339D1.3080509@goop.org> <20080321185434.GB23139@localdomain>
In-Reply-To: <20080321185434.GB23139@localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> Well, vSMPowered bits in the kernel serves two objectives:
> a) Internode cacheline size
> b) paravirt irq ops
>
> A vSMPowered machine can boot without either, but both affect performance.
> Both these bits are not interdependent.  The paravirt ops
> need the PARAVIRT infrastructure and that is all that is needed.
> The internode cacheline size needs a compile time definition that's all.
> CONFIG_X86_VSMP chooses both.  However, there is no reason to have paravirt
> irq ops depend on the Internode cacheline size.  More so since pv ops
> has the capability to detect the system type dynamically and using
> appropriate pv ops.
>   

So are you saying that X86_VSMP is just to select the internode 
cacheline size, and is independent of the pvops side of things?

If so, I think it would be worth adding a separate config variable so 
that you have the following:

VSMP (depends on PCI) - master selector for all vsmp-related code; 
enables vsmp detection code
VSMP && PARAVIRT - installs paravirt irq ops on a vsmp system
VSMP_CACHELINE_SIZE (depends on VSMP) - selects internode cacheline size

that way vsmp_64.o can just depend on VSMP, and at the very least 
contains the query code, and the other features are independently 
selectable.

    J
