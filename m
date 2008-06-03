Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbYFCKM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbYFCKM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYFCKMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:12:16 -0400
Received: from www.tglx.de ([62.245.132.106]:43744 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYFCKMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:12:14 -0400
Date: Tue, 3 Jun 2008 12:11:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Dabrunz <od@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
Message-ID: <alpine.LFD.1.10.0806031201010.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf,

On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
> These patches are against linux-2.6-tip, auto-x86-next.
> 
> When IRQ lines on secondary or higher IO-APICs are masked (as done by
> RT and others), many chipsets redirect IRQs on this line to the PIC, and
> thereby regularly to the first IO-APIC in the system. This causes
> spurious interrupts and can lead to disabled IRQ lines.
> 
> Disabling this "boot interrupt" (as it is mostly used to supply all
> IRQs to the legacy PIC during boot) is chipset-specific, and not
> possible for all chips. This patchset disables the boot interrupt on
> chipsets where this is possible and where we know how to do it.
> 
> When disabling the boot interrupt is not possible, the patches tell the
> IRQ code to always use the redirected interrupt line (on the first
> IO-APIC) instead of the "original" line on the secondary (tertiary ...)
> IO-APIC. The original line remains masked, and IRQs always appear on
> the boot interrupt line on the first IO-APIC instead.

Thanks for doing the research on this problem. 

We probably don't want to enable this unconditionally right away, so
we should have a command line option which enables these quirks.

Also is there any interaction with MSI ?

Thanks,
	tglx
