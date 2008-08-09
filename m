Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYHIQDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYHIQDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 12:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYHIQDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 12:03:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37637 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYHIQDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 12:03:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
	<1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
	<m1ej4zvw6s.fsf@frodo.ebiederm.org>
	<86802c440808081838r66cc8162t5c2e157908457048@mail.gmail.com>
	<489CFA0A.5030609@zytor.com>
	<86802c440808090030k7269590ftf233a13a21a2e37e@mail.gmail.com>
Date: Sat, 09 Aug 2008 09:02:00 -0700
In-Reply-To: <86802c440808090030k7269590ftf233a13a21a2e37e@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 9 Aug 2008 00:30:06 -0700")
Message-ID: <m14p5uuqh3.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0300]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 08/42] introduce nr_irqs
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

>> Also, what's the point, if it's just a renaming?
>
> that is the start point.
> nr_irqs is variable, and will be probed later. and use that number to
> init dyn_alloc.

YH. 

In my conception the code in kernel/irq.c that today does:

struct irq_desc *desc;
if (irq >= NR_IRQS)
   return -EINVAL;
desc = irq_desc + irq;

Should become:

struct irq_desc *desc;
desc = irq_desc(irq);
if (!desc)
   return -EINVAL;

Eric

