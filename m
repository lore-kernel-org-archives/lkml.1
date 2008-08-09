Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYHIBDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYHIBDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYHIBDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:03:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52744 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbYHIBDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:03:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
Date: Fri, 08 Aug 2008 18:00:59 -0700
In-Reply-To: <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
	(Yinghai Lu's message of "Fri, 8 Aug 2008 14:52:14 -0700")
Message-ID: <m1ej4zvw6s.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0155]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 08/42] introduce nr_irqs
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> and at this point it is equal NR_IRQS

This patch is ok, but this approach is fundamentally broken. 
Only 19 architectures use GENERIC_HARDIRQS

The only required interface is interrupt.h not irq.h

So you may not replace NR_IRQS with nr_irqs in anything other
then genirq code and some architecture code.

Doing so will break the build on several architectures.

Eric
