Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbYDMIqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbYDMIqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYDMIpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:45:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56883 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbYDMIpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:45:52 -0400
Date: Sun, 13 Apr 2008 10:45:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] x86: Cleanup prose of Documentation/i386/IO-APIC.txt
Message-ID: <20080413084536.GB24429@elte.hu>
References: <20080411154053.GD18242@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411154053.GD18242@tull.net>
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


* Nick Andrew <nick@nick-andrew.net> wrote:

> I'm doing a couple of cleanups to Documentation/i386/IO-APIC.txt
> and I have a problem with this line, which is supposed to compute
> a sample pirq= kernel parameter:
> 
>    echo -n pirq=; echo `scanpci | grep T_L | cut -c56-` | sed 's/ /,/g'
> 
> The 'scanpci' command used to be part of xutils and/or XFree86.
> Xorg implements "Xorg -scanpci" but the output is different and it won't
> run while X is running.
> 
> Firstly I propose using the $( ) construct rather than backticks, since
> it is easier to read:
> 
>    echo -n pirq=; echo $( scanpci | grep T_L | cut -c56- ) | sed 's/ /,/g'
> 
> Inside the backtics, instead of scanpci, I could do:
> 
>    lspci -v | grep IRQ | sed -e 's/.* IRQ \(\w\+\)/\1/'
> 
> Is this an acceptable substitution?

yeah, i guess so.

Btw., that's rather arcane text - do people still have to use pirq= boot 
lines to get their boxes to boot?

	Ingo
