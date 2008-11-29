Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYK2SXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYK2SXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 13:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYK2SXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 13:23:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51799 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYK2SXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 13:23:01 -0500
Message-ID: <49318871.8010501@redhat.com>
Date: Sat, 29 Nov 2008 20:22:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, lguest@ozlabs.org,
       jeremy@xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64,	i386: interrupt dispatch changes
References: <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com> <49178E89.2000307@zytor.com> <492DC13F.8020009@redhat.com> <492DE3EF.8060507@zytor.com> <492E72D7.9060201@redhat.com> <20081128204809.GA17920@mailshack.com> <20081129154516.GA26579@mailshack.com>
In-Reply-To: <20081129154516.GA26579@mailshack.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> I now did the benchmarks for the same -rc6 with hpa's 4-byte stubs
> too. Same machine. It's significantly better than the other two
> options in terms of speed. It takes about 7% less cpu to handle
> the interrupts. (0.64% cpu instead of 0.69%.) I have to run now,
> I'll let interpreting the histogram to someone else ;).
>   

This is noise. 0.05% cpu on a 1GHz machine servicing 1000 interrupt/sec 
boils down to 500 cycles/interrupt.  These changes shouldn't amount to 
so much (and I doubt you have 1000 interrupts/sec with a single disk)..

I'm sorry, but the whole effort is misguided, in my opinion.  If you 
want to optimize, try reducing the number of interrupts that occur 
rather than saving a few cycles in the interrupt path.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

