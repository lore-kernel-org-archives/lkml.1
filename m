Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191Ab0AZGRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0AZGRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665Ab0AZGRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:17:34 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49730 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0AZGR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:17:27 -0500
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>, Americo Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
References: <2375c9f91001252125w6f5bd3d3he183c61e9dcedd3e@mail.gmail.com>
	<20100126142644.5AB0.A69D9226@jp.fujitsu.com>
	<20100126144641.5AB3.A69D9226@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 25 Jan 2010 22:17:15 -0800
In-Reply-To: <20100126144641.5AB3.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's message of "Tue\, 26 Jan 2010 14\:49\:12 +0900 \(JST\)")
Message-ID: <m14om9jspg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

>> > On Tue, Jan 26, 2010 at 11:20 AM, KOSAKI Motohiro
>> > <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > > Hi
>> > >
>> > > Current linus tree made following lockdep warning when starting emacs command.
>> > > Is this known issue?
>> > >
>> > >
>> > > =========================================================
>> > > [ INFO: possible irq lock inversion dependency detected ]
>> > > 2.6.33-rc5 #77
>> > > ---------------------------------------------------------
>> > > emacs/1609 just changed the state of lock:
>> > >  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>] tty_fasync+0xe8/0x190
>> > > but this lock took another, HARDIRQ-unsafe lock in the past:
>> > >  (&(&sighand->siglock)->rlock){-.....}
>> > >
>> > > and interrupts could create inverse lock ordering between them.
>> > >
>> > >
>> > 
>> > Hey,
>> > 
>> > does reverting commit 703625118 help?
>> 
>> Seems solved.
>> 
>> Thanks.
>
> I'm sorry.
> I forgot to cc related person at last mail.
>
> Greg, can you please consider revert commit 703625118?

It looks like f_modown needs to do irqsave irqrestore to be safely
called in this context.  My apologies for missing this when I
originally made the suggestion.

As for the other comments I would be very surprised if lock_kernel()
offers any real protection.

I really don't understand what it is talking about siglock being
irq unsafe, that seems wrong on oh so many levels.

Eric

n
