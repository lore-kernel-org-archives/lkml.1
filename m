Return-Path: <linux-kernel-owner+w=401wt.eu-S1422760AbYHFUn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422760AbYHFUn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbYHFUnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:43:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53580 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbYHFUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:43:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	<m1hc9yjb7x.fsf@frodo.ebiederm.org>
	<86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	<86802c440808061150h3ad31052j8aa5ccc4a54edb2d@mail.gmail.com>
Date: Wed, 06 Aug 2008 13:32:49 -0700
In-Reply-To: <86802c440808061150h3ad31052j8aa5ccc4a54edb2d@mail.gmail.com>
	(Yinghai Lu's message of "Wed, 6 Aug 2008 11:50:53 -0700")
Message-ID: <m17iatkhou.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1673]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

>>>
>>> - Introduce get_irq_desc and the functions or function modifications
>>>  that pass a struct irq_desc * into the genirq code.
>>>
>>>  Although I absolutely hate the name get_irq_desc as it implies we are
>>>  reference counting something and need a corresponding put_irq_desc.
>>>  Since the lifetime rules don't require that.  Please just call the
>>>  function irq_desc().
>>
>> will check that.
>>
> how about get_irq_desc_without_new()?
>
> irq_desc_without_new()

Possibly irq_desc_with_new() or even create_irq_desc in the one or two code paths that care.
Everywhere else can reasonably assume that the irq_desc entries have either been setup, or that
the irq number is invalid.

Eric

