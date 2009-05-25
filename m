Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZEYRQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZEYRQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbZEYRQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:16:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52105 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZEYRQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:16:39 -0400
Message-ID: <4A1AD274.6030305@redhat.com>
Date: Mon, 25 May 2009 20:16:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 2.6.30-rc7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The upcoming F11 release has uncovered a couple of bugs relating to the 
reloading to the PDPTRs in PAE guests.  While the bugs are not recent 
regressions, the switch to PAE as a default kernel, coupled with the use 
of the fancy priority inherited futexes in audio code, cause the bug to 
start affecting people.

Futexes enter into the picture here as their initialization code 
deliberately writes into the NULL pointer.  If the PDPTRs have not been 
correctly reloaded, this write hits the low kernel mappings, and the 
write succeeds where the code expects it to fail, disabling the pi futex 
subsystem.

So please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.30

To get

Avi Kivity (2):
      KVM: Make paravirt tlb flush also reload the PAE PDPTRs
      KVM: Fix PDPTR reloading on CR4 writes

 arch/x86/kvm/mmu.c |    3 +--
 arch/x86/kvm/x86.c |    6 +++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

-- 
error compiling committee.c: too many arguments to function

