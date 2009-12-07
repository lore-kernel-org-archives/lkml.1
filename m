Return-Path: <linux-kernel-owner+w=401wt.eu-S935633AbZLGWYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935633AbZLGWYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934457AbZLGWYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:24:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54739 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934388AbZLGWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:24:13 -0500
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>
References: <20091130100041.GA29610@infradead.org>
	<alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
	<20091130174638.GA9782@elte.hu>
	<alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
	<1259616429.26472.499.camel@laptop>
	<alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
	<alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
	<m1y6lg7q3n.fsf@fess.ebiederm.org>
	<20091207181816.GF6808@linux.vnet.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 07 Dec 2009 14:24:13 -0800
In-Reply-To: <20091207181816.GF6808@linux.vnet.ibm.com> (Paul E. McKenney's message of "Mon\, 7 Dec 2009 10\:18\:16 -0800")
Message-ID: <m1ocma1kz6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [rfc] "fair" rw spinlocks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>
> Is it required that all of the processes see the signal before the
> corresponding interrupt handler returns?  (My guess is "no", which
> enables a trick or two, but thought I should ask.)

Not that I recall.  I think it is just an I/O completed signal.

>> The trouble as I recall is how to ensure new processes see the signal.
>
> And can we afford to serialize signals to groups of processes?  Not
> necessarily one at a time, but a limited set at a given time?
> Alternatively, a long list of pending group signals for each new task to
> walk?

Semantically I don't believe there are not any particular ordering
requirements, except that the work must be done before we return from
the kernel.

In the ideal implementation we could have hundreds of processes sending
signals to the same process group without affecting the rest of the
kernel.  The current implementation is a concern for scaling and we have
been removing it where we can.  

Eric
