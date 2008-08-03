Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYHCGne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYHCGne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 02:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYHCGnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 02:43:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42001 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYHCGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 02:43:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<m1fxpm8x3n.fsf@frodo.ebiederm.org>
	<86802c440808022304g41749d9dn7688c81c3fdbed8a@mail.gmail.com>
Date: Sat, 02 Aug 2008 23:39:18 -0700
In-Reply-To: <86802c440808022304g41749d9dn7688c81c3fdbed8a@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 2 Aug 2008 23:04:18 -0700")
Message-ID: <m18wve7gbt.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0038]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Sat, Aug 2, 2008 at 10:51 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> It appears that quite a few of the places you have changed are testing
>> to see if an irq is valid.  The idiomatic way to perform that test in
>> the kernel is:
>>
>> if (irq)
>
> is uninitialized irq to be -1 or 0?

0.  There is a long history behind it, but by decree of Linus and to conform
with reasonable intuition 0 is not a valid irq except in certain arch specific
corner cases.

>> With no test to see if you are >= NR_IRQS.
>>
>> I expect that is the change we want in the drivers that are performing such a
> silly
>> extra check.
>
> is_irq_valid(irq_no) ?
>
> wait to see your new patchset about dyn irq_cfg and irq_desc

I haven't promised one, at least not lately.  I went down a couple of
blind alleys and figured out what needed to be accomplished and then
ran out of steam about a year and a half 2 years ago, and I haven't
been able to get back to it.

Eric
