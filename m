Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968085Ab0B0JiG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:38:06 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54465 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968061Ab0B0JiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:38:03 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
References: <20100207210250.GB8256@jenkins.home.ifup.org>
	<tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
	<4B881097.1050505@kernel.org> <20100227091043.GA31794@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 27 Feb 2010 01:37:52 -0800
In-Reply-To: <20100227091043.GA31794@elte.hu> (Ingo Molnar's message of "Sat\, 27 Feb 2010 10\:10\:43 +0100")
Message-ID: <m1wrxzqarz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
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

> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> 
>> for x86, with radix tree based irq_to_desc(),
>> removing arch_probe_nr_irqs is intentional. so we get more irq that could be used.
>> 
>> wonder if the udev for some of your test system have irq number limitation?
>
> was ancient udev: udev-095-17.fc6.

Something doesn't add up.  Nowhere in the udev source is there a
single mention of irq.

gsi have fixed interrupt numbers so that would not change.

The dynamic irqs are allocated starting from the high gsi
and working up.

The irq numbers that get allocated should not have changed,
unless this was actually a bug fix in this configuration.

The other possibility is that somehow arch_probe_nr_irqs()
was returning a number greater than NR_IRQS.

Ingo do you have any idea what NR_IRQS or nr_irqs were/are on
that failing machine?

Eric
