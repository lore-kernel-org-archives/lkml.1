Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZFDNNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZFDNNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZFDNNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:13:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34917 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZFDNNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:13:05 -0400
Date: Thu, 4 Jun 2009 15:20:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/2] KVM: Add VT-x machine check support
Message-ID: <20090604132023.GC1065@one.firstfloor.org>
References: <20090604112.650907584@firstfloor.org> <20090604111205.C47C31D0282@basil.firstfloor.org> <4A27B481.5020003@redhat.com> <20090604125123.GY1065@one.firstfloor.org> <4A27C2BF.3090108@redhat.com> <20090604130107.GA1065@one.firstfloor.org> <4A27C7B6.6030709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A27C7B6.6030709@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:10:14PM +0300, Avi Kivity wrote:
> Andi Kleen wrote:
> >>vmcs access work because we have a preempt notifier called when we are 
> >>scheduled in, and will execute vmclear/vmptrld as necessary.  Look at 
> >>kvm_preempt_ops in virt/kvm_main.c.
> >>    
> >
> >I see. So we need to move that check earlier. Do you have a preference
> >where it should be?
> >  
> 
> There's no good place as it breaks the nice exit handler table.  You 
> could put it in vmx_complete_interrupts() next to NMI handling.

I think I came up with a easy cheesy but not too bad solution now that should 
work. It simply remembers the CPU in the vcpu structure and schedules back to 
it. That's fine for this purpose. 

Currently testing the patch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
