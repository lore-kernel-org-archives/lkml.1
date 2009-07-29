Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbZG2NxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbZG2NxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbZG2NxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:53:09 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:55268 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932095AbZG2NxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:53:06 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNJQJS-04-678-01
Date: Wed, 29 Jul 2009 15:52:41 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] kvm/svm: cache nested intercepts
Message-ID: <20090729135241.GM18313@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
 <1248872192-30881-9-git-send-email-joerg.roedel@amd.com>
 <4A7053AF.60301@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A7053AF.60301@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 13:52:42.0029 (UTC) FILETIME=[D7AD9DD0:01CA1053]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 03:50:39PM +0200, Alexander Graf wrote:
> Joerg Roedel wrote:
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kvm/svm.c |   30 +++++++++++++++++++++++-------
> >  1 files changed, 23 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 31467b1..9192c9a 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -86,6 +86,15 @@ struct nested_state {
> >  
> >  	/* gpa pointers to the real vectors */
> >  	u64 vmcb_msrpm;
> > +
> > +	/* cache for intercepts of the guest */
> > +	u16 intercept_cr_read;
> > +	u16 intercept_cr_write;
> > +	u16 intercept_dr_read;
> > +	u16 intercept_dr_write;
> > +	u32 intercept_exceptions;
> > +	u64 intercept;
> > +
> >  };
> >  
> >  struct vcpu_svm {
> > @@ -1459,7 +1468,6 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
> >  					void *arg2,
> >  					void *opaque)
> >  {
> > -	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
> >   
> 
> That's not enough. You actually have to make the caller not pass it as
> argument too. Otherwise a good idea.

Yeah, true. Thats planned but not yet done. Today I just sent out what I have
so far :) This will surely be part of the second cleanup round.

	Joerg


