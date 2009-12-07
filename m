Return-Path: <linux-kernel-owner+w=401wt.eu-S965180AbZLGXUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180AbZLGXUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965091AbZLGXUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:20:04 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49180 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935672AbZLGXUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:20:03 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
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
	<m1ocma1kz6.fsf@fess.ebiederm.org> <87ws0y76q7.fsf@basil.nowhere.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 07 Dec 2009 15:19:59 -0800
In-Reply-To: <87ws0y76q7.fsf@basil.nowhere.org> (Andi Kleen's message of "Mon\, 07 Dec 2009 23\:35\:28 +0100")
Message-ID: <m1fx7m1ie8.fsf@fess.ebiederm.org>
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

Andi Kleen <andi@firstfloor.org> writes:

> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>>>
>>> Is it required that all of the processes see the signal before the
>>> corresponding interrupt handler returns?  (My guess is "no", which
>>> enables a trick or two, but thought I should ask.)
>>
>> Not that I recall.  I think it is just an I/O completed signal.
>
> Wasn't there the sysrq SAK too? That one definitely would need
> to be careful about synchronicity.

SAK from sysrq is done through schedule work, I seem to recall the
locking being impossible otherwise.  There is also send_sig_all and a
few others from sysrq.  I expect we could legitimately make them
schedule_work as well if needed.

Eric
