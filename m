Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYGKXwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYGKXwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYGKXwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:52:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50254 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbYGKXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182239.205057000@linux-os.sc.intel.com>
	<m1fxqhdxji.fsf@frodo.ebiederm.org>
	<20080711060714.GT1678@linux-os.sc.intel.com>
	<m1hcawaj9v.fsf@frodo.ebiederm.org>
	<20080711230711.GX1678@linux-os.sc.intel.com>
Date: Fri, 11 Jul 2008 16:50:08 -0700
In-Reply-To: <20080711230711.GX1678@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Fri, 11 Jul 2008 16:07:12 -0700")
Message-ID: <m1fxqg6kwf.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0050]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 23/26] x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> On Fri, Jul 11, 2008 at 01:59:24AM -0700, Eric W. Biederman wrote:

> Sure. Will probably introduce irq_mapping_ops (which may be as simple as
> ops containing specific msi_compose_msg, ioapic_compose_rte, etc). This
> should simiplify the setup code. I will look into this and post these patches
> next week.

Thanks.  I am a little leery of separate hooks for different message
types.  As they are just different ways of encoding the information
for an interrupt message.  The index parameter seems to have placed
the same bits in the same relative location for both msi and the
ioapic_rte.  Which suggests to me that we have an architecturally
defined correspondence between the bits.  If that is indeed the case
and if we can continue to do that we should be able to keep the
complexity of the arch code down with sharing code, and letting the
iommu be oblivious to what part of the architecture will be sending
interrupt messages.

Although looking at it.  In theory if not in practice there are 64 bits
in an ioapic_rte message and 36 bits in an msi message (as long as we 
maintain the architecturally standard window).  So we may actually
be able to encode more information in one message then in the other.

>> need multiple irq_chip structures (although it may be worth it if we
>> can detect we can optimize irq migration).
>
> Depending on the IOMMU/hardware, they may define different irq_chip's
> if they add/simplify functionality, or may  use existing irq_chip's.

There are a lot of variables, as long as end result is relatively clean
and maintainable.

Eric
