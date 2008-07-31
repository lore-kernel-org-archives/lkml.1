Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYGaSNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYGaSNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYGaSNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:13:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35736 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYGaSND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:13:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com>
	<200807302109.21519.yhlu.kernel@gmail.com>
	<200807302110.10585.yhlu.kernel@gmail.com>
	<200807310126.12572.yhlu.kernel@gmail.com>
	<m1iqum2rya.fsf@frodo.ebiederm.org>
	<20080731145752.2aec5727@lxorguk.ukuu.org.uk>
Date: Thu, 31 Jul 2008 11:10:33 -0700
In-Reply-To: <20080731145752.2aec5727@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Thu, 31 Jul 2008 14:57:52 +0100")
Message-ID: <m163ql3ox2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4206]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] serial: change remove NR_IRQS in 8250.c
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Thu, 31 Jul 2008 04:50:21 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> > replace
>> > 	[PATCH] serial: change irq_lists to use dyn_array
>> > use small array with index to handle irq locking for serial port
>> > hope 32 slot is enough
>> 
>> Could you size this array by NR_UARTS (our worst case usage)
>> and place irq_no in struct irq_info?
>
> NR_UARTS is likely to go away in time so don't get attached to it

I'm not attached to it, but NR_UARTS is a closer approximation to what
we are trying to do then YH's hard coded 32.  Do you know if we
actually need the list of uarts per irq or if request_irq having a
shared isa would work?

The practical question is how do we cleanly kill the array
irq_lists[NR_IRQS].  YH's hack where he isn't paying attention to what
the code is doing and just trying to avoid the problem is not
something I am fond of seeing being merged.

It is also true that sorting out 8250.c and by extension the other
serial drivers that have cloned it is the significant non-arch
piece of work needed to kill NR_IRQs

Eric


