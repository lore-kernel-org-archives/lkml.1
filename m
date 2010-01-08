Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582Ab0AHHMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0AHHMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 02:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982Ab0AHHMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 02:12:05 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:53717 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0AHHME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 02:12:04 -0500
Date: Fri, 8 Jan 2010 08:12:00 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: "Zhang, Xiantao" <xiantao.zhang@intel.com>
Cc: Roel Kluin <roel.kluin@gmail.com>,
       "kvm-ia64@vger.kernel.org" <kvm-ia64@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: dereference of NULL pointer in set_pal_result()
Message-ID: <20100108071200.GB15621@boogie.lpds.sztaki.hu>
References: <4B465C2D.8030303@gmail.com>
 <EB8593BCECAB3D40A8248BE0B6400A38315E5831@shzsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A38315E5831@shzsmsx502.ccr.corp.intel.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 07:28:57AM +0800, Zhang, Xiantao wrote:

> For the check "(p && p->exit_reason == EXIT_REASON_PAL_CALL", if p is NULL, the reference about "p->exit_reason == EXIT_REASON_PAL_CALL" won't be checked any more, so no issue here. 

> > diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
> > index e4b8231..d28494f 100644
> > --- a/arch/ia64/kvm/kvm_fw.c
> > +++ b/arch/ia64/kvm/kvm_fw.c
> > @@ -75,9 +75,11 @@ static void set_pal_result(struct kvm_vcpu *vcpu,
> >  	struct exit_ctl_data *p;
> > 
> >  	p = kvm_get_exit_data(vcpu);
> > -	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
> > +	if (!p)
> > +		return;
> > +	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
> >  		p->u.pal_data.ret = result;
> > -		return ;
> > +		return;
> >  	}
> >  	INIT_PAL_STATUS_UNIMPLEMENTED(p->u.pal_data.ret);

IMHO it's not the test but the INIT_PAL_STATUS_UNIMPLEMENTED() that does
the unwanted dereferencing, and that's fixed by the patch.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
