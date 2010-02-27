Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968165Ab0B0KMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:12:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53245 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968123Ab0B0KMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:12:43 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
References: <20100207210250.GB8256@jenkins.home.ifup.org>
	<tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
	<4B881097.1050505@kernel.org> <20100227091043.GA31794@elte.hu>
	<m1wrxzqarz.fsf@fess.ebiederm.org> <20100227095313.GG31794@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 27 Feb 2010 02:12:34 -0800
In-Reply-To: <20100227095313.GG31794@elte.hu> (Ingo Molnar's message of "Sat\, 27 Feb 2010 10\:53\:13 +0100")
Message-ID: <m1zl2voulp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add arch_probe_nr_irqs() again
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

>> Ingo do you have any idea what NR_IRQS or nr_irqs were/are on
>> that failing machine?
>
> Sorry, not - and the merge window doesnt leave much time to revisit the 
> problem right now.
>
> But the failures were very real and 100% caused by this: they resulted in 
> non-existent /dev/sda* nodes and resulting fsck failure by rc.

I have looked it over a second time and I have convinced myself
that arch_probe_nr_irqs will in the worst case reduce nr_irqs,
and never increase it beyond NR_IRQS.  So this revert (keeping
arch_probe_nr_irqs) is safe.

It makes little sense that a larger nr_irqs would be a problem,
but clearly there are assumptions somewhere that we still need
to remove.

Eric
