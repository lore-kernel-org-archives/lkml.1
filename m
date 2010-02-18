Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab0BRRFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:05:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37542 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0BRRFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:05:13 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>
	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>
	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org>
	<m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org>
	<4B7CAAEC.1000608@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Feb 2010 09:04:57 -0800
In-Reply-To: <4B7CAAEC.1000608@kernel.org> (Yinghai Lu's message of "Wed\, 17 Feb 2010 18\:50\:20 -0800")
Message-ID: <m1r5oiv5ja.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC PATCH 3/3] genericirq: change ack/mask in irq_chip to take irq_desc in addition to irq
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> will have
> void            (*ack)(unsigned int irq, struct irq_desc *desc);
> void            (*mask)(unsigned int irq, struct irq_desc *desc);
> void            (*mask_ack)(unsigned int irq, struct irq_desc *desc);
> void            (*unmask)(unsigned int irq, struct irq_desc *desc);
> void            (*eoi)(unsigned int irq, struct irq_desc *desc);
>
> so for sparseirq with raidix tree, we don't call extra irq_to_desc, and could use desc directly

This doesn't look bad.  

May I ask why these methods and why pass both irq and desc instead of
just desc?

I think in the long run passing both irq and desc through several
functions may incur some maintenance cost that it would be nice not to
pay (register pressure and increased chance of typos).

With a big sweeping change like this I want to be certain we won't
change our minds and come back and want to change it all again.

Oh and a multiarch patch like this should really cc linux-arch
so the arch maintainers can see it.

In passing it looks like want to transform get_irq_data in hpet.c to
get_irq_desc_data.

Eric
