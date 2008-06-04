Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbYFDSqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbYFDSqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYFDSqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:46:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbYFDSqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:46:31 -0400
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
From: Jon Masters <jcm@redhat.com>
To: Stefan Assmann <sassmann@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4846651F.4070802@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
	 <m1tzgauduu.fsf@frodo.ebiederm.org>  <4846651F.4070802@suse.de>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 14:44:00 -0400
Message-Id: <1212605040.8410.8.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-04 at 11:49 +0200, Stefan Assmann wrote:

> On the chips (ICHx, ...) we saw, the interrupt lines on the PIC also go
> to the first IO-APIC. So the boot interrupts go to both the PIC and the
> first IO-APIC.

Yup, it's system dependent too, but it's a mess in many cases. I've seen
numerous systems falling over - typically, the classical case will be
some IO controller when under heavy load will stop doing interrupts.
Another gotcha is that a lot of the time, these legacy interrupt (boot
interrupts) happen to be shared between e.g. a disk controller and a USB
host controller. On a server system running -RT, it's quite common that
there won't be much going on with the other device, so the problem goes
unnoticed for a long time...but it still bites you in the end.

> When running in APIC mode all PIC IRQs are disabled, except for the
> timer maybe. Boot interrupts still arrive on the first IO-APIC and end
> up as being counted as spurious interrupts.

Yup. I think the good thing is that both SuSE and Red Hat have
identified the same problems, posited the same root cause, and
contemplated similar workarounds...so I think we understand it.

Jon.


