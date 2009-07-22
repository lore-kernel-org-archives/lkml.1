Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbZGVV3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbZGVV3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZGVV3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:29:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56516 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZGVV3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:29:43 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo\@redhat.com" <mingo@redhat.com>,
       "hpa\@zytor.com" <hpa@zytor.com>,
       "tglx\@linutronix.de" <tglx@linutronix.de>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Yinghai Lu <yinghai@kernel.org>
References: <tip-e25371d60cb06a44d7a32d7966ab9bfbeacb9390@git.kernel.org>
	<4A676E89.9010606@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 22 Jul 2009 14:29:33 -0700
In-Reply-To: <4A676E89.9010606@goop.org> (Jeremy Fitzhardinge's message of "Wed\, 22 Jul 2009 12\:54\:49 -0700")
Message-ID: <m1hbx4mmo2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, yinghai@kernel.org, Jeremy.Fitzhardinge@citrix.com, tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  8.0 XMSpecificSbj Contains a known spam subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [tip:x86/apic] x86/ioapic.c: unify ioapic_retrigger_irq()
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> On 07/18/09 05:05, tip-bot for Jeremy Fitzhardinge wrote:
>> Commit-ID:  e25371d60cb06a44d7a32d7966ab9bfbeacb9390
>> Gitweb:     http://git.kernel.org/tip/e25371d60cb06a44d7a32d7966ab9bfbeacb9390
>> Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> AuthorDate: Mon, 8 Jun 2009 03:49:01 -0700
>> Committer:  Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> CommitDate: Tue, 14 Jul 2009 13:32:51 -0700
>>
>> x86/ioapic.c: unify ioapic_retrigger_irq()
>>
>> The 32 and 64-bit versions of ioapic_retrigger_irq() are identical
>> except the 64-bit one takes vector_lock.  vector_lock is defined and
>> used on 32-bit too, so just use a common ioapic_retrigger_irq().
>>   
>
> Having another look at this patch, the other difference is that the
> 32-bit version just does:
>
>     apic->send_IPI_self(irq_cfg(irq)->vector);
>
> whereas the 64-bit does:
>
>     apic->send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)),
>     cfg->vector);
>
>
> Does 32-bit do the whole vector domain thing now?  Are these actually
> equivalent?  Sending to self seems like it should be more efficient.

It should.  I believe YH did that work when he merged the x86_64 and
i386 versions io_apic.c.  Sending to self is a problem if we retrigger
this from the wrong irq.

Eric
