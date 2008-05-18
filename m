Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYERMKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYERMKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbYERMK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:10:26 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:27633 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbYERMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lV0nrlBn6+MvhxzbU7PWlUC/iQ3aSi1yNU4PymXSMisON+ir0EUQHKwhWSG0k9xSvZJfUuFd4+V+moUJm/pGxvpOIEGA8lVyDAvNQrTLPK3MJkuDH7YwjYDW0MTgJ1b0XlE1A1HjW4ECeLA+qZFb49JDLMUbNyIRvlPT3Zrxex8=
Date: Sun, 18 May 2008 16:10:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tom Spink <tspink@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518121009.GK6948@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <483001C4.1010801@firstfloor.org> <20080518102015.GH6948@cvg> <48300426.8080300@firstfloor.org> <20080518102914.GI6948@cvg> <7b9198260805180507r67d7aff3u339ff873e8893096@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805180507r67d7aff3u339ff873e8893096@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Tom Spink - Sun, May 18, 2008 at 01:07:37PM +0100]
| 2008/5/18 Cyrill Gorcunov <gorcunov@gmail.com>:
| > [Andi Kleen - Sun, May 18, 2008 at 12:25:42PM +0200]
| > | Cyrill Gorcunov wrote:
| > |
| > | > yes, but what to do with absence of __nmi_count on 32bit and die_nmi
| > | > uses different number of args? gcc follows both pathes anyway trying
| > | > to evaluate where I prefer it would not... I mean I've got errors
| > | > on compiling procedue 'cause of different number of args for die_nmi
| > | > used in 32bit mode. That is why I've asked Thomas if it possible to
| > | > add "panic" boot option for 32bit mode and make it familiar with 64bit
| > | > mode and merge them eventually.
| > |
| > | Sorry just pointed out why the Kconfig idea doesn't work, nothing more.
| > |
| > | If you want to avoid ifdefs then you have to unify the functionality
| > | first. Putting syntactical sugar on ifdefs doesn't make sense.
| > |
| > | I haven't kept track of the exact state of the code, but if the per cpu
| > | data macros are finally as efficient as the PDA you could move the
| > | nmi_count to per_cpu in both for once.
| > |
| > | -Andi
| > |
| >
| > ok, thanks
| >
| >                - Cyrill -
| >
| 
| It looks, though, that the unification of traps_{32,64}.c might help
| eliminate some of these conditionals.  After a quick glance, at the
| traps source, certainly the __die_nmi helper might even be eliminated.
| 
| -- 
| Regards,
| Tom Spink
| 

yes, I've already unified them so I use single form for both cases. I'll
send updated version on the week probably.

		- Cyrill -
