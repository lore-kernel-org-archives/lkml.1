Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbYGLACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbYGLACX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 20:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYGLACO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 20:02:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39876 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbYGLACM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 20:02:12 -0400
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
	<m1d4lkauxc.fsf@frodo.ebiederm.org>
	<20080711231543.GY1678@linux-os.sc.intel.com>
Date: Fri, 11 Jul 2008 16:59:42 -0700
In-Reply-To: <20080711231543.GY1678@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Fri, 11 Jul 2008 16:15:43 -0700")
Message-ID: <m163rc6kgh.fsf@frodo.ebiederm.org>
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
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Multiple MSI, take 3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> And why do we need to mask/unmask the device in the interrupt-remapping case?

Why do we ever?  It is part of the linux irq API and people wind up using
it in all kinds of strange ways.

One of the more surprising uses I have see is for the real time kernel
people mask the irq, wake up a kernel thread (to handle the irq), then
ack the irq and get out of the interrupt handler.  It looked like
people working on UIO were starting to implement something similar.

>> Speaking of.  How many interrupt targets does the dmar iommu have
>> for interrupts?  16K?
>
> There can be multiple interrupt-remapping units in the platform and
> each of table in the remapping unit has max 64K entries.

Thanks.  That should last us for a little while. :)

Eric
