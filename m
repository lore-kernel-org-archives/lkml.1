Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYESSIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYESSIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYESSIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:08:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:29641 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYESSIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Jao9Lyfm1gmZDj+7QWroXqc9TnVbrC5XYt9QpenlMDC2OLE650Dw0X4aElu6oX6gk3UdSb8pp+t1SxD9K4b5yEPSvw+QkQI/ClsMMh1dI24+9+wov1cOAbMijJADmpLkXIWwUHp/BunbpRD9jdLJ7/Q9CG2IT8syCRBNs5JlRWU=
Date: Mon, 19 May 2008 22:07:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080519180753.GB7773@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <18479.21161.437325.251769@harpo.it.uu.se> <alpine.LFD.1.10.0805180023100.18798@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805180023100.18798@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, if someone is still watching this thread - I've found a bit strange
behaviour of nmi on 32bit platform. Look, we have 

	nmi_watchdog = NMI_DEFAULT

by default which is the alias to NMI_DISABLED. Then lets assume that
user put some option on command line, say for example he passes something
like that

	nmi_watchdog=2

which set it to

	nmi_watchdog = NMI_LOCAL_APIC

with only that option passed we have sysfs entry created
but I can't figure out why in proc_nmi_enabled() we have this
code

	if (nmi_watchdog == NMI_DEFAULT) {
		if (lapic_watchdog_ok())
			nmi_watchdog = NMI_LOCAL_APIC;
		else
			nmi_watchdog = NMI_IO_APIC;
	}

it seems it just _dont need_ at and could be safetly removed.
Did I miss something?

		- Cyrill -
