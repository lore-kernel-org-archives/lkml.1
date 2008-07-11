Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYGKKMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYGKKMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYGKKMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:12:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50058 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYGKKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:12:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
References: <20080711005719.GO14894@parisc-linux.org>
Date: Fri, 11 Jul 2008 03:06:33 -0700
In-Reply-To: <20080711005719.GO14894@parisc-linux.org> (Matthew Wilcox's
	message of "Thu, 10 Jul 2008 18:57:19 -0600")
Message-ID: <m1iqvc91li.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Wilcox <matthew@wil.cx>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Multiple MSI, take 3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> I'd like to thank Michael Ellerman for his feedback.  This is a much
> better patchset than it used to be.

There is a reason we don't have an API to support this.  Linux can not
reasonably support this, especially not on current X86.  The designers
of the of the AHCI were idiots and should have used MSI-X.

Attempting to support multiple irqs in an MSI capability breaks
every interesting use of an irq.

mask/unmask is will likely break because the mask bit is optional
and when it is not present we disable the msi capability.

We can not set the affinity individually so we can not allow
different queues to be processed on different cores.

So in general it seems something that we have to jump through a million
hurdles and the result is someones twisted parody of a multiple working
irqs, that even Intel's IOMMU can't cure.

So unless the performance of the AHCI is better by a huge amount I don't
see the point, and even then I am extremely sceptical.

Eric
