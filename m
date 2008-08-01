Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbYHAWxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbYHAWxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbYHAWxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:53:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47487 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441AbYHAWxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:53:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	<m1iqukwjjg.fsf@frodo.ebiederm.org>
	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
	<86802c440808011457g5b72d69bq768cf815046957ec@mail.gmail.com>
Date: Fri, 01 Aug 2008 15:45:23 -0700
In-Reply-To: <86802c440808011457g5b72d69bq768cf815046957ec@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 1 Aug 2008 14:57:13 -0700")
Message-ID: <m1abfwnym4.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Fri, Aug 1, 2008 at 2:30 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Fri, Aug 1, 2008 at 1:46 PM, Eric W. Biederman <ebiederm@xmission.com>
> wrote:
>
>>> http://lkml.org/lkml/2008/7/10/439
>
> you moved kstat_irqs to irqdesc, and it will not numa-aware. if
> irq_desc is not go with every cpu.

That part is a limitation of the per cpu allocator that the sgi guys
are in the process of fixing.  Which is one of the following goals
of folding the pda into a per cpu structure.

In practice it matters little as irqs only occur on one cpu at a time,
so we shouldn't have cache line contention.

I never got to the arch specific part of allocating irq_desc in a numa
aware fashion.  But I have always figured that if we move the work to
arch code it won't be too difficult, to do things appropriately.

Eric
