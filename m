Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZFHH7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZFHH7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZFHH7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:59:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42340 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbZFHH7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:59:02 -0400
Message-ID: <4A2CC4C2.4050901@redhat.com>
Date: Mon, 08 Jun 2009 10:58:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM fix for 2.6.30-rc8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, if it's not too late, please pull

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.30

this fixes a crash during reboot with the kvm modules loaded if 
CONFIG_SMP is selected.

If you merge the larger cpumask initializing allocator, you can drop this.


Avi Kivity (1):
      KVM: Explicity initialize cpus_hardware_enabled

 virt/kvm/kvm_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

commit a4c0364be3f43d3e17fe19270f8b3d64881606e6
Author: Avi Kivity <avi@redhat.com>
Date:   Sat Jun 6 12:34:39 2009 +0300

    KVM: Explicity initialize cpus_hardware_enabled
   
    Under CONFIG_MAXSMP, cpus_hardware_enabled is allocated from the 
heap and
    not statically initialized.  This causes a crash on reboot when kvm 
thinks
    vmx is enabled on random nonexistent cpus and accesses nonexistent 
percpu
    lists.
   
    Fix by explicitly clearing the variable.
   
    Cc: stable@kernel.org
    Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Avi Kivity <avi@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ecbe23..4293528 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2305,6 +2305,7 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
         r = -ENOMEM;
         goto out_free_0;
     }
+    cpumask_clear(cpus_hardware_enabled);
 
     r = kvm_arch_hardware_setup();
     if (r < 0)

-- 
error compiling committee.c: too many arguments to function

