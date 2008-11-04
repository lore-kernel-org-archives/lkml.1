Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbYKDSQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbYKDSQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYKDSQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:16:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51382 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYKDSQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:16:33 -0500
Date: Tue, 4 Nov 2008 16:15:40 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/16] x86: Make nmi_shootdown_cpus() available on !SMP
	and !X86_LOCAL_APIC
Message-ID: <20081104181540.GK23893@blackpad>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <1225810364-8990-8-git-send-email-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225810364-8990-8-git-send-email-ehabkost@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, Nov 04, 2008 at 12:52:35PM -0200, Eduardo Habkost wrote:
> The X86_LOCAL_APIC #ifdef was for kdump. For !SMP, the function simply
> does nothing.
> 

The bit below is also needed. It can be added to the series right before
patch 07/16.

After getting some review, I will resubmit the series with it, and with
a few style fixes suggested by checkpatch.

---
From: Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 06.1/16] x86: Disable IRQs before doing anything on nmi_shootdown_cpus()

We need to know on which CPU we are running on, and we don't want to be
preempted while doing this.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/reboot.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 23a9d78..407106e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -577,6 +577,7 @@ static struct notifier_block crash_nmi_nb = {
 void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
 	unsigned long msecs;
+	local_irq_disable();
 
 	/* Make a note of crashing cpu. Will be used in NMI callback.*/
 	crashing_cpu = safe_smp_processor_id();
-- 
1.5.5.GIT


-- 
Eduardo
