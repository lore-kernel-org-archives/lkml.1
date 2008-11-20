Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYKTU0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYKTU0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYKTUZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:25:56 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55584 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYKTUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:25:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
References: <patchbomb.1226603398@abulafia.goop.org>
	<d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
	<20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org>
Date: Thu, 20 Nov 2008 12:22:33 -0800
In-Reply-To: <492597B9.8070506@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 20 Nov 2008 09:00:41 -0800")
Message-ID: <m1y6ze87w6.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0494]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Ingo Molnar wrote:
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>
>>> Writes to the IO APIC are paravirtualized via hypercalls, so implement
>>> the appropriate operations.
>>>
>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>> ---
>>>  arch/x86/xen/Makefile    |    3 +-
>>> arch/x86/xen/apic.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  arch/x86/xen/enlighten.c |    2 +
>>>  arch/x86/xen/xen-ops.h   |    2 +
>>>  4 files changed, 72 insertions(+), 1 deletion(-)
>>>
>>
>> hm, why is the ioapic used as the API here, and not an irqchip?
>>
>
> In essence, the purpose of the series is to break the 1:1 relationship between
> Linux irqs and hardware GSIs.

Bad idea (I think).  We have a 1:1 relationship between the linux irq number and
the GSI because it makes the code dramatically simpler, and it took significant
work to get there.  The concept of an intermediate mapping layer sounds nasty.
But I haven't yet read the patch.

> If the x86 interrupt layer in general decouples irqs from GSIs, then I can
> probably make use of that to clean things up.  A general irq allocator along
> with some way of attaching interrupt-source-specific information to each irq
> would get me a long way, I think.  I'd still need hooks to paravirtualize the
> actual ioapic writes, but at least I wouldn't need to have quite so much
> delicate hooking.

I know that is where I thought the sparse irq code was going.

Eric

