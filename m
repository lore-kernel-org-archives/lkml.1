Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYGaLxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYGaLxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYGaLxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:53:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57027 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYGaLw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:52:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com>
	<200807302109.21519.yhlu.kernel@gmail.com>
	<200807302110.10585.yhlu.kernel@gmail.com>
	<200807310126.12572.yhlu.kernel@gmail.com>
Date: Thu, 31 Jul 2008 04:50:21 -0700
In-Reply-To: <200807310126.12572.yhlu.kernel@gmail.com> (Yinghai Lu's message
	of "Thu, 31 Jul 2008 01:26:12 -0700")
Message-ID: <m1iqum2rya.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1522]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] serial: change remove NR_IRQS in 8250.c
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> replace
> 	[PATCH] serial: change irq_lists to use dyn_array
> use small array with index to handle irq locking for serial port
> hope 32 slot is enough

Could you size this array by NR_UARTS (our worst case usage)
and place irq_no in struct irq_info?

Also you want to hold irq_info->lock when you set or clear irq_no.
Just to be on the safe side.  I expect we can avoid clearing the irq_no
in the irq_lists and prevent a few more races from being a possibility.

Eric
