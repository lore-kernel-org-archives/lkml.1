Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbYCUSy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbYCUSy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYCUSys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:54:48 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:42459 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYCUSys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:54:48 -0400
Date: Fri, 21 Mar 2008 11:54:34 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: Re: [patch 2/4] x86: Fix build breakage when PCI is define and PARAVIRT is not
Message-ID: <20080321185434.GB23139@localdomain>
References: <20080320073740.GA9414@localdomain> <20080320074116.GC9414@localdomain> <47E339D1.3080509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E339D1.3080509@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 09:30:09PM -0700, Jeremy Fitzhardinge wrote:
>Ravikiran G Thirumalai wrote:
>>- Fix the the build breakage when PARAVIRT is defined
>>  but PCI is not
>>  This fixes problem reported at:
>>	http://marc.info/?l=linux-kernel&m=120525966600698&w=2
>>- Make is_vsmp_box() available even when PARAVIRT is not defined.
>>  This is needed to determine if tsc's are reliable as a time source
>>  even when PARAVIRT is not defined.
>>- split vsmp_init to use is_vsmp_box() and set_vsmp_pv_ops()
>>  set_vsmp_pv_ops will do nothing if PCI is not enabled in the config.
>>  
>
>I'm a bit confused by all the config dependencies.  I had assumed that 
>VSMP depended on both PCI and PARAVIRT.  Is this not actually true?  You 
>can have a VSMP system without either or both of PCI/PARAVIRT?

Well, you could have a vSMPowered system without PARAVIRT, yes.  But a non
PCI vSMPowered system does not exist to my knowledge.

>
>The structure of the code suggests that at the very least VSMP depends 
>on PCI (it never makes sense to enable VSMP on a non-PCI system), and 
>therefore a number of your config decisions can just be predicated on VSMP.

Well, vSMPowered bits in the kernel serves two objectives:
a) Internode cacheline size
b) paravirt irq ops

A vSMPowered machine can boot without either, but both affect performance.
Both these bits are not interdependent.  The paravirt ops
need the PARAVIRT infrastructure and that is all that is needed.
The internode cacheline size needs a compile time definition that's all.
CONFIG_X86_VSMP chooses both.  However, there is no reason to have paravirt
irq ops depend on the Internode cacheline size.  More so since pv ops
has the capability to detect the system type dynamically and using
appropriate pv ops.

Thanks,
Kiran
