Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYHBCnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYHBCnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYHBCnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:43:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37302 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYHBCnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:43:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	<m1iqukwjjg.fsf@frodo.ebiederm.org>
	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
	<m1wsj0nyx6.fsf@frodo.ebiederm.org>
	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>
	<m163qkjirc.fsf@frodo.ebiederm.org>
	<86802c440808011901w2aa40b25u45f5686b262cc2aa@mail.gmail.com>
	<4893C066.60401@zytor.com>
Date: Fri, 01 Aug 2008 19:39:42 -0700
In-Reply-To: <4893C066.60401@zytor.com> (H. Peter Anvin's message of "Fri, 01
	Aug 2008 19:03:18 -0700")
Message-ID: <m1abfwi1ht.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1697]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> I also see little value in stably encoding IRQ numbers using geographical
> identifiers.  It seems that the only case where you care that an interrupt
> number is stable is when it is *not* tied to a geographically addressed entity,
> so why does it matter?

In the case of msi it is a minor. In the case of GSIs from ACPI it dramatically
simplified the code, and improved it's reliability.  Because then everyone including
ACPI was always using the same.

So in general principle I think we should have stable irq numbers if we can.  Which
allows someone to say I have a problem with irq X.  And it will always be irq X on
their box.  An extra level of indirection makes debugging more difficult.

Having a human readable name like: eth0irq22 or hbairq5 is likely just
as good in the case of msi.  Still all of the users interfaces today take numbers.
So we are stuck with dealing with numbers for a long time to come.

Eric
