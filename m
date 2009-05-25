Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZEYFRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZEYFRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZEYFRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:17:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:39360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZEYFRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:17:41 -0400
Subject: Re: [PATCH -tip] x86: kvm/paging_tmpl.h intialize the variable
 before using it
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A193BCE.90307@redhat.com>
References: <1242793775.3260.2.camel@localhost.localdomain>
	 <4A193BCE.90307@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 May 2009 10:47:06 +0530
Message-Id: <1243228626.3157.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi,

On Sun, 2009-05-24 at 15:21 +0300, Avi Kivity wrote:
> Jaswinder Singh Rajput wrote:
> > May be in some cases paging64_fetch() and paging32_fetch() will return sptep
> > without initialization.
> >
> > Also fixes compilation warning:
> >   CC      arch/x86/kernel/io_delay.o
> >  arch/x86/kvm/paging_tmpl.h: In function ‘paging64_fetch’:
> >  arch/x86/kvm/paging_tmpl.h:279: warning: ‘sptep’ may be used uninitialized in this function
> >  arch/x86/kvm/paging_tmpl.h: In function ‘paging32_fetch’:
> >  arch/x86/kvm/paging_tmpl.h:279: warning: ‘sptep’ may be used uninitialized in this function
> >
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/kvm/paging_tmpl.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> > index 6bd7020..99cb10d 100644
> > --- a/arch/x86/kvm/paging_tmpl.h
> > +++ b/arch/x86/kvm/paging_tmpl.h
> > @@ -276,7 +276,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
> >  {
> >  	unsigned access = gw->pt_access;
> >  	struct kvm_mmu_page *shadow_page;
> > -	u64 spte, *sptep;
> > +	u64 spte, *sptep = NULL;
> >  	int direct;
> >  	gfn_t table_gfn;
> >  	int r;
> >   
> 
> It's a false alarm.  Isn't there a macro to shut up the warning?
> 

In arch/x86/kvm/paging_tmpl.h sptep is initialize only in :

for_each_shadow_entry(vcpu, addr, iterator) {

If we skip this, then we end up with wild sptep and returning it.

Do you still think it is a false alarm ?

--
JSR


