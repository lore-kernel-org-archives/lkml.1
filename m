Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbXL0Gvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbXL0Gvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 01:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXL0Gvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 01:51:48 -0500
Received: from il.qumranet.com ([82.166.9.18]:56036 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbXL0Gvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 01:51:47 -0500
Message-ID: <47734B82.5000805@qumranet.com>
Date: Thu, 27 Dec 2007 08:51:46 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/55] KVM patch queue review for 2.6.25 merge window
 (part II)
References: <1198667160-22953-1-git-send-email-avi@qumranet.com> <20071226204752.GA3383@uranus.ravnborg.org>
In-Reply-To: <20071226204752.GA3383@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Dec 26, 2007 at 01:05:05PM +0200, Avi Kivity wrote:
>   
>> The second 2.6.25 kvm patch series, for your review.  Three more to go.
>>     
>
> Hi Avi.
>
> A diffstat in your introduction mail would be nice so one does not
> have to check 50+ patches to see if it touches any file I can give
> feedback on.
>
>   

Right, sorry for not including it originally:

(this is the diffstat for the entire patchset, not just this batch)

 arch/x86/Kconfig                                   |    6 +
 arch/x86/Makefile                                  |    2 +
 {drivers => arch/x86}/kvm/Kconfig                  |    4 +-
 {drivers => arch/x86}/kvm/Makefile                 |    6 +-
 {drivers => arch/x86}/kvm/i8259.c                  |    8 +-
 {drivers => arch/x86}/kvm/irq.c                    |   22 +-
 arch/x86/kvm/irq.h                                 |   88 +
 {drivers => arch/x86}/kvm/kvm_svm.h                |    2 +-
 {drivers => arch/x86}/kvm/lapic.c                  |  141 +-
 arch/x86/kvm/lapic.h                               |   44 +
 {drivers => arch/x86}/kvm/mmu.c                    | 1016 ++++--
 arch/x86/kvm/mmu.h                                 |   44 +
 {drivers => arch/x86}/kvm/paging_tmpl.h            |  410 +--
 arch/x86/kvm/segment_descriptor.h                  |   29 +
 {drivers => arch/x86}/kvm/svm.c                    |  347 +-
 {drivers => arch/x86}/kvm/svm.h                    |    3 +-
 {drivers => arch/x86}/kvm/vmx.c                    | 1068 +++---
 {drivers => arch/x86}/kvm/vmx.h                    |   26 +-
 drivers/kvm/kvm_main.c => arch/x86/kvm/x86.c       | 4099 
+++++++++-----------
 arch/x86/kvm/x86_emulate.c                         | 1912 +++++++++
 drivers/Kconfig                                    |    2 -
 drivers/Makefile                                   |    1 -
 drivers/kvm/irq.h                                  |  165 -
 drivers/kvm/segment_descriptor.h                   |   17 -
 drivers/kvm/x86_emulate.c                          | 1662 --------
 include/asm-x86/Kbuild                             |    1 +
 include/asm-x86/kvm.h                              |  176 +
 drivers/kvm/kvm.h => include/asm-x86/kvm_host.h    |  530 +--
 include/asm-x86/kvm_para.h                         |  105 +
 .../asm-x86/kvm_x86_emulate.h                      |   69 +-
 include/linux/Kbuild                               |    2 +-
 include/linux/kvm.h                                |  162 +-
 include/linux/kvm_host.h                           |  290 ++
 include/linux/kvm_para.h                           |   80 +-
 include/linux/kvm_types.h                          |   54 +
 kernel/fork.c                                      |    1 +
 {drivers => virt}/kvm/ioapic.c                     |   99 +-
 virt/kvm/ioapic.h                                  |   95 +
 virt/kvm/iodev.h                                   |   63 +
 virt/kvm/kvm_main.c                                | 1393 +++++++
 40 files changed, 8139 insertions(+), 6105 deletions(-)

As you can see, the {drivers/ -> virt/, arch/x86/} transition dominates 
the diffstat.  Note that this does not include ia64 support, which is 
planned for the 2.6.25 merge window and only awaits a bit of paperwork.

The Kconfig/Makefile changes which are probably most of interest to you 
should arrive in the last batch.

-- 
error compiling committee.c: too many arguments to function

