Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZJHQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZJHQQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZJHQQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:16:52 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:55254
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753891AbZJHQQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:16:51 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432R98dN936eM179dN9371Pzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KR7EID-04-9TY-02
X-M-MSG: 
Date: Thu, 8 Oct 2009 18:15:45 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] KVM: SVM: Add tracepoint for nested vmrun
Message-ID: <20091008161545.GE14073@amd.com>
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
 <1254996199-17667-4-git-send-email-joerg.roedel@amd.com>
 <4ACE0C1E.40506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4ACE0C1E.40506@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Oct 2009 16:15:45.0433 (UTC) FILETIME=[971D6090:01CA4832]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 05:58:22PM +0200, Avi Kivity wrote:
> On 10/08/2009 12:03 PM, Joerg Roedel wrote:
> >This patch adds a dedicated kvm tracepoint for a nested
> >vmrun.
> >
> >Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >---
> >  arch/x86/kvm/svm.c   |    6 ++++++
> >  arch/x86/kvm/trace.h |   33 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.c   |    1 +
> >  3 files changed, 40 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >index 884bffc..907af3f 100644
> >--- a/arch/x86/kvm/svm.c
> >+++ b/arch/x86/kvm/svm.c
> >@@ -1726,6 +1726,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
> >  	/* nested_vmcb is our indicator if nested SVM is activated */
> >  	svm->nested.vmcb = svm->vmcb->save.rax;
> >
> >+	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, svm->nested.vmcb,
> >+			       nested_vmcb->save.rip,
> >+			       nested_vmcb->control.int_ctl,
> >+			       nested_vmcb->control.event_inj,
> >+			       nested_vmcb->control.nested_ctl);
> >+
> 
> It's better to pass only 'svm' as argument and have the tracepoint
> code derive everything else, since (I think) argument setup is done
> unconditionally, and only the actual trace_kvm call is patched out.
> It may not work out due to where the trace code is compiled, but
> it's worth trying.

Hmm, struct vcpu_svm is defined in svm.c and local to that file. It is
not known in x86.c, where the tracepoints are compiled, or in svm.c
where trace.h is included. Is this tracepoint it worth it to move the
definition of vcpu_svm into a (x86-)global header?

	Joerg


