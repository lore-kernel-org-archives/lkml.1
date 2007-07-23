Return-Path: <linux-kernel-owner+w=401wt.eu-S1762523AbXGWG4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762523AbXGWG4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbXGWG4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:56:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:55412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbXGWG4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:56:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271462841"
Subject: [RFC 0/8]KVM: swap out guest pages
From: Shaohua Li <shaohua.li@intel.com>
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:51:29 +0800
Message-Id: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series make kvm guest pages be able to be swapped out and
dynamically allocated. Without it, all guest memory is allocated at
guest start time.

patches are against latest git, and you need first patch Avi's kvm-sch
integration patch
(http://sourceforge.net/mailarchive/forum.php?thread_name=11841693332609-git-send-email-avi%40qumranet.com&forum_name=kvm-devel ).

Patch is quite stable in my test. With the patch, I can run a 256M
memory guest in a 300M memory host. If guest is idle, the memory it used
can be less than 10M. I did a simple performance test (measure kernel
build time in guest), if there is few swap, the performance w/wo the
patch difference isn't significent. If you have better measurement
approach, please let me try.

Unresolved issue:
1. swapoff doesn't work, we need a hook.
2. SMP guest might not work, as kvm doesn't support smp till now.
3. better algorithm to select swaped out guest pages according to
guest's memory usage.
Maybe more.

Any suggests and comments are appreciated.

Thanks,
Shaohua
