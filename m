Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZENFbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZENFbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 01:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZENFbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 01:31:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:43879 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZENFbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 01:31:20 -0400
Subject: [PATCH -tip] x86: kvm/x86.c use MSR names in place of address
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1242032889.8213.32.camel@yhuang-dev.sh.intel.com>
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
	 <1242032701.3114.4.camel@localhost.localdomain>
	 <1242032889.8213.32.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 11:00:10 +0530
Message-Id: <1242279010.4574.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 17:08 +0800, Huang Ying wrote:
> On Mon, 2009-05-11 at 17:05 +0800, Jaswinder Singh Rajput wrote:
> > On Mon, 2009-05-11 at 16:48 +0800, Huang Ying wrote:
> > > +int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> > > +{
> > > +	u64 data;
> > > +
> > > +	switch (msr) {
> > > +	case 0xc0010010: /* SYSCFG */
> > > +	case 0xc0010015: /* HWCR */
> > 
> > You can replace this with :
> > 
> > +	case MSR_K8_SYSCFG:
> > +	case MSR_K8_HWCR:
> > 
> 
> I do not change this actually. So I think it should be changed in
> another patch.
> 

Here is the patch:

[PATCH -tip] x86: kvm/x86.c use MSR names in place of address

Replace 0xc0010010 with MSR_K8_SYSCFG and 0xc0010015 with MSR_K7_HWCR.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c1ce5a..8e4a0ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -866,8 +866,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	u64 data;
 
 	switch (msr) {
-	case 0xc0010010: /* SYSCFG */
-	case 0xc0010015: /* HWCR */
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
@@ -888,6 +886,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
 	case MSR_IA32_LASTINTTOIP:
+	case MSR_K8_SYSCFG:
+	case MSR_K7_HWCR:
 	case MSR_VM_HSAVE_PA:
 		data = 0;
 		break;
-- 
1.6.0.6



