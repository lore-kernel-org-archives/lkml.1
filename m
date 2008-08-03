Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYHCFxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYHCFxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 01:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYHCFxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 01:53:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40192 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYHCFxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 01:53:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
Date: Sat, 02 Aug 2008 22:51:40 -0700
In-Reply-To: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	(Yinghai Lu's message of "Sat, 2 Aug 2008 19:59:00 -0700")
Message-ID: <m1fxpm8x3n.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0596]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It appears that quite a few of the places you have changed are testing
to see if an irq is valid.  The idiomatic way to perform that test in
the kernel is:

if (irq)

With no test to see if you are >= NR_IRQS.

I expect that is the change we want in the drivers that are performing such a silly
extra check.

Eric


