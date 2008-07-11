Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYGKXCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYGKXCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYGKXCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:02:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36507 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYGKXCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:02:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
References: <20080711005719.GO14894@parisc-linux.org>
	<m1iqvc91li.fsf@frodo.ebiederm.org>
	<20080711215943.GW1678@linux-os.sc.intel.com>
Date: Fri, 11 Jul 2008 15:59:59 -0700
In-Reply-To: <20080711215943.GW1678@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Fri, 11 Jul 2008 14:59:43 -0700")
Message-ID: <m1d4lkauxc.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1458]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Multiple MSI, take 3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> With interrupt-remapping, we can program the individual interrupt
> remapping table entries to point to different cpu's etc. All we have
> to take care is, do the IRTE allocation in a consecutive block and
> program the starting index to the MSI registers.
>
> Just curious Eric, why do you think that won't work?

Working mask/unmask.  With MSI-X as specced if I mask an irq and then unmask
it, an msi message will fire if something happened while the irq was masked
and not taken care of before the irq was unmasked.  That is the correct
behavior for an irq and a mmu won't let me get that.

The best I can do with an iommu is to run delayed disable and set the
interrupt remapping slot in the iommu to reject the traffic.  Which
is almost but not quite what I want.

Overall introducing a new concept into the linux irq model seems a lot
cleaner and more portable, and even there we are likely to be a lot
more fragile because of the difficulty in obtaining contiguous
vectors.

Speaking of.  How many interrupt targets does the dmar iommu have
for interrupts?  16K?

Eric
