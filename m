Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbZEHM5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbZEHM5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZEHM5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:57:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34652 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbZEHM5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:57:24 -0400
Date: Fri, 8 May 2009 10:02:03 -0300
From: Glauber Costa <glommer@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated
	instruction
Message-ID: <20090508130203.GD5953@poweredge.glommer>
References: <1241548811-8138-1-git-send-email-glommer@redhat.com> <20090506080321.GU9795@redhat.com> <4A016B98.7070701@redhat.com> <20090508052511.GC5953@poweredge.glommer> <20090508071814.GC25357@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508071814.GC25357@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 10:18:14AM +0300, Gleb Natapov wrote:
> On Fri, May 08, 2009 at 02:25:11AM -0300, Glauber Costa wrote:
> > On Wed, May 06, 2009 at 01:51:04PM +0300, Avi Kivity wrote:
> > > Gleb Natapov wrote:
> > >> On Tue, May 05, 2009 at 02:40:11PM -0400, Glauber Costa wrote:
> > >>   
> > >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > >>> index 8e680c3..a49d07b 100644
> > >>> --- a/arch/x86/include/asm/kvm_host.h
> > >>> +++ b/arch/x86/include/asm/kvm_host.h
> > >>> @@ -510,6 +510,8 @@ struct kvm_x86_ops {
> > >>>  	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
> > >>>  	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> > >>>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> > >>> +	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
> > >>>     
> > >> There is .drop_interrupt_shadow() callback. The patch should remove it and
> > >> replace its use by set_interrupt_shadow().
> > >>   
> > >
> > > That would be [PATCH 1/2].
> > [PATCH 2/2]. Otherwise we will break bisectability, as the pure removal of this
> > function would lead us to a non-functioning kernel for no reason.
> > 
> > Avi: if this patch is okay, please apply. I'll send another one later that replaces
> > the existing .drop_interrupt_shadow by the (then) in tree set_interrupt_shadow.
> > 
> It is not always easy to understand what Avi means :) but my
> interpretation was that patch 1/2 should replace drop_interrupt_shadow()
> with set_interrupt_shadow() and 2/2 should be only emulation changes.
ok... I'll send an updated version.
