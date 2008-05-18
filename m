Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbYERKZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbYERKZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 06:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYERKZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 06:25:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43048 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYERKZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 06:25:45 -0400
Message-ID: <48300426.8080300@firstfloor.org>
Date: Sun, 18 May 2008 12:25:42 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <483001C4.1010801@firstfloor.org> <20080518102015.GH6948@cvg>
In-Reply-To: <20080518102015.GH6948@cvg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:

> yes, but what to do with absence of __nmi_count on 32bit and die_nmi
> uses different number of args? gcc follows both pathes anyway trying
> to evaluate where I prefer it would not... I mean I've got errors
> on compiling procedue 'cause of different number of args for die_nmi
> used in 32bit mode. That is why I've asked Thomas if it possible to
> add "panic" boot option for 32bit mode and make it familiar with 64bit
> mode and merge them eventually.

Sorry just pointed out why the Kconfig idea doesn't work, nothing more.

If you want to avoid ifdefs then you have to unify the functionality
first. Putting syntactical sugar on ifdefs doesn't make sense.

I haven't kept track of the exact state of the code, but if the per cpu
data macros are finally as efficient as the PDA you could move the
nmi_count to per_cpu in both for once.

-Andi

