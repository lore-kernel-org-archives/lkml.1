Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbZIRXMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbZIRXMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 19:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758295AbZIRXMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 19:12:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33773 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbZIRXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 19:12:14 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Wu Fei <at.wufei@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org, jeremy@goop.org,
       mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
References: <20090901133709.GA24041@redhat.com>
	<20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com>
	<20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org>
	<20090902091340.GA5173@redhat.com> <20090904073749.GB20598@elte.hu>
	<20090918163241.GA8556@desktop> <20090918185425.GA16620@redhat.com>
	<alpine.LFD.2.01.0909181217270.4950@localhost.localdomain>
	<20090918211218.GA19351@redhat.com>
	<alpine.LFD.2.01.0909181504400.4950@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Sep 2009 16:11:56 -0700
In-Reply-To: <alpine.LFD.2.01.0909181504400.4950@localhost.localdomain> (Linus Torvalds's message of "Fri\, 18 Sep 2009 15\:06\:02 -0700 \(PDT\)")
Message-ID: <m18wgbc0g3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill kthreadd_task_init_done
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, 18 Sep 2009, Oleg Nesterov wrote:
>> 
>> Not sure I understand... We don't have CLONE_PID, and kthreadd()
>> shouldn't have pid == 0 anyway.
>
> Ahh, we got rid of CLONE_PID a long time ago, and renamed it to 
> CLONE_IDLETASK (which was what it was used for).
>
> As to why pid == 0 wouldn't work, I don't know, but I'll take your word 
> for it.

It probably would work but it would not be visible in proc  Making a kernel
thread that actually does work seems undesirable.

Eric
