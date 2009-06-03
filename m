Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbZFCMDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbZFCMDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZFCMD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:03:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48751 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbZFCMD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:03:26 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining triggered "active" device IRQ interrruption
References: <20090602193216.GC7282@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 05:03:24 -0700
In-Reply-To: <20090602193216.GC7282@us.ibm.com> (Gary Hade's message of "Tue\, 2 Jun 2009 12\:32\:16 -0700")
Message-ID: <m1prdlttgz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, yinghai@kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> Impact: Eliminates an issue that can leave the system in an
>         unusable state.
>
> This patch addresses an issue where device generated IRQs
> are no longer seen by the kernel following IRQ affinity
> migration while the device is generating IRQs at a high rate.
>
> I have been able to consistently reproduce the problem on
> some of our systems by running the following script (VICTIM_IRQ
> specifies the IRQ for the aic94xx device) while a single instance
> of the command
>   # while true; do find / -exec file {} \;; done
> is keeping the filesystem activity and IRQ rate reasonably high.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Again you are attempt to work around the fact that fixup_irqs
is broken.

fixup_irqs is what needs to be fixed to call these functions properly.

We have several intense debug sessions by various people including
myself that show that your delayed_irq_move function will simply not
work reliably.

Frankly simply looking at it gives me the screaming heebie jeebies.

The fact you can't reproduce the old failure cases which demonstrated
themselves as lockups in the ioapic state machines gives me no
confidence in your testing of this code.

Eric
