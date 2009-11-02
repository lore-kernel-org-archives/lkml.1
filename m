Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZKBQmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZKBQmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbZKBQmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:42:52 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:42274 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbZKBQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:42:51 -0500
Subject: Re: KVM: powerpc: Fix BUILD_BUG_ON condition
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091102170815.86e2daf7.sfr@canb.auug.org.au>
References: <20091102170815.86e2daf7.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 02 Nov 2009 08:42:31 -0800
Message-Id: <1257180151.11206.3.camel@slab>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 17:08 +1100, Stephen Rothwell wrote:
> Hi Hollis, Avi,
> 
> This commit was added to the kvm tree recently:
> 
> > Author: Hollis Blanchard <hollisb@us.ibm.com>
> > Date:   Fri Oct 23 00:35:30 2009 +0000
> > 
> >     KVM: powerpc: Fix BUILD_BUG_ON condition
> >     
> >     The old BUILD_BUG_ON implementation didn't work with __builtin_constant_p().
> >     Fixing that revealed this test had been inverted for a long time without
> >     anybody noticing...
> >     
> >     Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
> >     Signed-off-by: Avi Kivity <avi@redhat.com>
> > 
> > diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
> > index bb13b1f..a550f0f 100644
> > --- a/arch/powerpc/kvm/timing.h
> > +++ b/arch/powerpc/kvm/timing.h
> > @@ -48,7 +48,7 @@ static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type) {}
> >  static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
> >  {
> >  	/* type has to be known at build time for optimization */
> > -	BUILD_BUG_ON(__builtin_constant_p(type));
> > +	BUILD_BUG_ON(!__builtin_constant_p(type));
> >  	switch (type) {
> >  	case EXT_INTR_EXITS:
> >  		vcpu->stat.ext_intr_exits++;
> 
> It is OK as far as it goes.  It still does not build, though, due to the
> new BUILD_BUG_ON macro.

Correct.

> So I have still commented out the BUILD_BUG_ON in linux-next.

I've pointed out a few times that Rusty's patch (Subject "BUILD_BUG_ON:
make it handle more cases", Date "Tue, 20 Oct 2009 14:15:33 +1030") is
needed to fix the problem with BUILD_BUG_ON().

So far I haven't seen anybody acknowledge the patch or indicate it will
actually be committed.

-- 
Hollis Blanchard
IBM Linux Technology Center

