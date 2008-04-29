Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYD2O2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYD2O2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYD2O2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:28:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYD2O2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:28:41 -0400
Date: Tue, 29 Apr 2008 16:28:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: Sergio Luis <sergio@larces.uece.br>, Ken Moffat <zarniwhoop@ntlworld.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 slow boot/reboot
Message-ID: <20080429142819.GF26461@elte.hu>
References: <48141111.7010605@larces.uece.br> <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com> <20080427235554.GA28344@deepthought> <48152747.4030107@larces.uece.br> <4815DCEF.3000602@redhat.com> <430c4fa50804280735o3d1c3b9cg687f7d374dafbdec@mail.gmail.com> <48166CA1.1070000@redhat.com> <4816BDAD.3000906@larces.uece.br> <481713E3.1050007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481713E3.1050007@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <gcosta@redhat.com> wrote:

> [    1.375711] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
> sharing enabled
> [    4.399907] floppy0: no floppy controllers found
>
> a 90-second delay is not what's happening, or at least, not what the 
> kernel is seeing. So my bet would be something clock-related. Probably 
> the system's clocksource is not running the time correctly, which is 
> causing system events to be delayed. I fail to see, however, how does 
> the patch you bisected to influences this. Ingo, do you have any idea?

the first thing to check, does latest x86.git work fine:

  http://people.redhat.com/mingo/x86.git/README

? We've got fixes queued up - in particular one could result in 'slow' 
systems by virtue of denying an ioremap():

  Subject: revert: "x86: ioremap(), extend check to all RAM pages"

maybe the bisection went haywire.

Or the secondary core booted up in such a sucky way that it causes such 
massive slowdowns? Perhaps we are flooding the system with local APIC 
timer interrupts or other interrupts?

	Ingo
