Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYGKCCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYGKCCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 22:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYGKCCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 22:02:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41563 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbYGKCCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 22:02:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
       andi@firstfloor.org, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182239.635284000@linux-os.sc.intel.com>
	<m1r6a1fhc8.fsf@frodo.ebiederm.org> <20080710233733.GA21085@ywang-dev>
Date: Thu, 10 Jul 2008 18:53:42 -0700
In-Reply-To: <20080710233733.GA21085@ywang-dev> (Yong Wang's message of "Thu,
	10 Jul 2008 19:37:33 -0400")
Message-ID: <m14p6xdw49.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yong Wang <yong.y.wang@linux.intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 26/26] x64, x2apic/intr-remap: introduce CONFIG_INTR_REMAP
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Wang <yong.y.wang@linux.intel.com> writes:

> Yes, it is possible to run in x2apic mode without intr-remap. However, the
> extended
> cpu addressability will not be fully utilized that way.

Thanks.  I can see that as there are only about 16bits for the cpuid
in the irq routing entries.

Still it looks like we should enable x2apic if we can (as it is more
optimized) and should be faster.  Then if we have x2apic support
enable irq remapping if we can, although I'm not positive x2apic
support is required for the irq remapping.

Ultimately we should also enable directed ack when available instead
of broadcast ack for level triggered ioapic irqs.  That should also
reduce some rare but potentially unnecessary traffic.

Eric

