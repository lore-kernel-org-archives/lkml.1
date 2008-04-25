Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYDYCyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYDYCyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 22:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYDYCyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 22:54:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46446 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYDYCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 22:54:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
References: <20080422221733.GA16260@havoc.gtf.org>
	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
	<480E6DE5.6010103@garzik.org>
	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
	<480E796E.4070001@garzik.org>
	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
	<20080423000529.GG28933@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
	<m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org>
	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
	<4810A9E6.1080201@garzik.org>
	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
	<m1r6cvgpw2.fsf@frodo.ebiederm.org> <4810C3B5.3020605@garzik.org>
Date: Thu, 24 Apr 2008 19:53:51 -0700
In-Reply-To: <4810C3B5.3020605@garzik.org> (Jeff Garzik's message of "Thu, 24
	Apr 2008 13:30:29 -0400")
Message-ID: <m11w4u8x1c.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [git patch] free_irq() fixes
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Eric W. Biederman wrote:
>> And on x86 at least the hardware maps the MSI write into an interrupt.
>> So there is not an opportunity to get any metdata/OOB data from the
>> MSI message.  Instead we just potentially get a boatload more irq
>> sources.  Which is one of the things making a static NR_IRQS painful.
>>
>> To be safe we have to make NR_IRQS 10x+ or so bigger then people use
>> today.  Just in case they decide to plug in some really irq hungry
>> cards.
>
>
> Just to be clear, irq_chip/irq_desc and metadata/OOB data are two very different
> beasts.  irq_chip/irq_desc is more a system attribute as Linus notes.  Also, it
> doesn't change very often.
>
> metadata/OOB, on the other hand, is different -for each interrupt-, and is
> highly relevant to drivers.  Thus should be part of the driver API somehow.

I'm not certain I follow so I will ask.

Do you mean information that is different each time an interrupt is fires?

Or do you mean information that differs for each different interrupt?
Something like the current dev_id?

To my knowledge there is not any information that varies each time an
interrupt fires.

Eric
