Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbZJEK2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbZJEK2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbZJEK2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:28:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbZJEK2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:28:00 -0400
Message-ID: <4AC9CA10.5000105@redhat.com>
Date: Mon, 05 Oct 2009 12:27:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 2.6.32-rc3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please find in

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.32

some KVM fixes, most notably an EPT TLB fix on vcpu migration.  Also
included is glue code for ksm.  While KVM will work without this code,
any shared pages will be removed from the shadow page tables and unshared
on the next guest access, resulting in much thrashing.  With the new code,
the shadow ptes are simply downgraded to read-only access.

Aurelien Jarno (1):
       KVM: fix LAPIC timer period overflow

Avi Kivity (1):
       KVM: Prevent overflow in KVM_GET_SUPPORTED_CPUID

Christian Borntraeger (1):
       KVM: s390: fix memsize >= 4G

Izik Eidus (3):
       KVM: MMU: dont hold pagecount reference for mapped sptes pages
       KVM: MMU: add SPTE_HOST_WRITEABLE flag to the shadow ptes
       KVM: add support for change_pte mmu notifiers

Joerg Roedel (2):
       KVM: SVM: Fix tsc offset adjustment when running nested
       KVM: SVM: Handle tsc in svm_get_msr/svm_set_msr correctly

Marcelo Tosatti (1):
       KVM: VMX: flush TLB with INVEPT on cpu migration

  arch/s390/kvm/kvm-s390.h        |    2 +-
  arch/x86/include/asm/kvm_host.h |    1 +
  arch/x86/kvm/lapic.c            |    2 +-
  arch/x86/kvm/mmu.c              |   84 
++++++++++++++++++++++++++++++--------
  arch/x86/kvm/paging_tmpl.h      |   18 +++++++-
  arch/x86/kvm/svm.c              |   25 +++++++++---
  arch/x86/kvm/vmx.c              |    2 +-
  arch/x86/kvm/x86.c              |    2 +
  virt/kvm/kvm_main.c             |   14 ++++++
  9 files changed, 120 insertions(+), 30 deletions(-)

-- 
error compiling committee.c: too many arguments to function

