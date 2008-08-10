Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYHJTxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYHJTxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 15:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYHJTx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 15:53:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56011 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYHJTx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 15:53:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	<cX_-nNkxKaF.A.AGD.iEjnIB@albercik>
	<m1sktdsmyy.fsf@frodo.ebiederm.org> <489F31FC.9040104@zytor.com>
Date: Sun, 10 Aug 2008 12:51:51 -0700
In-Reply-To: <489F31FC.9040104@zytor.com> (H. Peter Anvin's message of "Sun,
	10 Aug 2008 11:22:52 -0700")
Message-ID: <m1wsior6lk.fsf@frodo.ebiederm.org>
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
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4980]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Bug #11201] kernel BUG at arch/x86/kernel/io_apic_64.c:357!
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.26.  Please verify if it still should be listed and let me know
>>> (either way).
>>
>> Yep.  There is a patch in -mm.  It seems the process is to wait for Thomas &
>> Ingo to get back before we send this to Linus.
>>
>
> Yes, unfortunately I still don't have enough testing resources to want to push
> this upstream.  I'm queuing it up for submission, though.

No problem.  I don't expect any problems as it is a simple reversion of the
definition of NR_IRQS on x86_64 to what we had before everything was merged
into irq_vectors.h and the x86_64 bits got lost.

With the result that NR_IRQS varies in practice between 244 and 4096
depending on how many cpus you have.  We have had NR_IRQS that large on
x86_64 for a year or better now so I don't expect any practical problems.

The long term fix will obviously be kill NR_IRQS.  But that is not a 2.6.27
term project.

Eric
