Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYERH0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYERH0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 03:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYERHZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 03:25:56 -0400
Received: from gw.goop.org ([64.81.55.164]:36620 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbYERHZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 03:25:55 -0400
Message-ID: <482FD9F2.8080204@goop.org>
Date: Sun, 18 May 2008 08:25:38 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>, Tom Spink <tspink@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Definitely, but we should do it at the Kconfig level which allows us
> to have integer defines as well, so we end up with something like:
>
> static inline unsigned int get_nmi_count(int cpu)
> {
>       return CONFIG_X86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
> }
>   

Unfortunately that doesn't work because when CONFIG_X86_64 isn't defined 
it doesn't expand to 0.  It would be nice if CONFIG_* expanded to 0/1, 
but we'd need to change all the #ifdef CONFIG_* to #if CONFIG_*...

    J
