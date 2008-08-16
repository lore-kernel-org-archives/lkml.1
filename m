Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYHPIX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYHPIX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 04:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYHPIXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 04:23:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53138 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYHPIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 04:23:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
Date: Sat, 16 Aug 2008 01:17:12 -0700
In-Reply-To: <200808160326.m7G3QR1G012726@terminus.zytor.com> (H. Peter
	Anvin's message of "Fri, 15 Aug 2008 20:26:33 -0700")
Message-ID: <m11w0p74s7.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3020]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> The 28 bits aren't enough, are they: we need domain as well (and surely we can
> have more than 16 domains?)

The justification is questionable.  The fact that the irq number
reported for msi-x vectors is only 16bits is a bug.  Everywhere else
in the kernel an irq number is stored in a 32bit field.

We also have a few other bits of craziness in the msix interface.
The entry field in msix_entry is unnecessary.

In fact now that we have a linked list of irq entries we stop passing
the structure entirely.

Eric
