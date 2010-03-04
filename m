Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0CDL14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:27:56 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:40059 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0CDL1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:27:54 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN936eMab9bhzz1202hzzz32i6bh2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYR966-02-3ZJ-02
X-M-MSG: 
Date: Thu, 4 Mar 2010 12:27:41 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] KVM: SVM: Report Nested Paging support to
 userspace
Message-ID: <20100304112740.GK31544@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <1267643541-451-18-git-send-email-joerg.roedel@amd.com>
 <023D03A7-4DBE-4E6E-911D-14E8FCADB459@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <023D03A7-4DBE-4E6E-911D-14E8FCADB459@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Mar 2010 11:27:41.0316 (UTC) FILETIME=[B3B3AC40:01CABB8D]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 12:37:42AM +0100, Alexander Graf wrote:
> 
> On 03.03.2010, at 20:12, Joerg Roedel wrote:
> 
> > This patch implements the reporting of the nested paging
> > feature support to userspace.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> > arch/x86/kvm/svm.c |   10 ++++++++++
> > 1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index fe1398e..ce71023 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -3289,6 +3289,16 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> > 
> > static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> > {
> > +	switch (func) {
> > +	case 0x8000000A:
> > +		if (!npt_enabled)
> > +			break;
> 
> if (!nested)
>   break;

True, but shouldn't matter much because if nested is off the guest will
not see the svm bit. It would only see that the processor could do
nested paging if it had svm support ;-)

	Joerg


