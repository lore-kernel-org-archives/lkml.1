Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbZKFAVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbZKFAVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759074AbZKFAVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:21:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48264 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbZKFAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:21:00 -0500
Date: Fri, 6 Nov 2009 11:21:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hollis Blanchard <hollisb@us.ibm.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-Id: <20091106112101.1dc05ed0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

Today's linux-next merge of the kvm tree got a conflict in
arch/powerpc/kvm/timing.h between commit
38634e6769920929385f1ffc8820dc3e893cc630 ("powerpc/kvm: Remove
problematic BUILD_BUG_ON statement") from Linus' tree and commit
8976402d633b79683667c44ca8252f9b26eebe71 ("KVM: powerpc: Fix BUILD_BUG_ON
condition") from the kvm tree.

Just context changes.  I fixed it up (see below) and can carry it for a
while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/kvm/timing.h
index 806ef67,a550f0f..0000000
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@@ -48,11 -48,7 +48,11 @@@ static inline void kvmppc_set_exit_type
  static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
  {
  	/* type has to be known at build time for optimization */
 +
 +	/* The BUILD_BUG_ON below breaks in funny ways, commented out
 +	 * for now ... -BenH
- 	BUILD_BUG_ON(__builtin_constant_p(type));
+ 	BUILD_BUG_ON(!__builtin_constant_p(type));
 +	*/
  	switch (type) {
  	case EXT_INTR_EXITS:
  		vcpu->stat.ext_intr_exits++;
