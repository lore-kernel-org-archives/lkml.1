Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbYBEVql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbYBEVql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760643AbYBEVqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:46:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:52436 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbYBEVqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:46:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UyiB0G1gmqWE5lzuWCYiswQ22ffFPqapcgw/Blrlz77GkB5pmcnGPc6zJwFWa3aijPk7M/qAWuN0EoVDojqvy6jPc9gGpe5shzvEGdKTXnmhrxQAa6qoyQ2OEg4r7RHYYAuGojqgsa/Ot5cMfGpBmNu0OvwnySAQCodO45f0oec=
Message-ID: <b647ffbd0802051346k563a44f7t42739515c130124b@mail.gmail.com>
Date: Tue, 5 Feb 2008 22:46:32 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper (bisected)
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200802020040.05519.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802010237.59320.rjw@sisk.pl> <200802011250.18699.rjw@sisk.pl>
	 <1201867797.32654.52.camel@lappy> <200802020040.05519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael, any progress with this issue? (a few questions below).

> >
> > Does this artsmessage thing also run with RT priority?
>
> Well, it's in a strange state (after it's broken).  From top:
>
> PR = -51
> NI = 0
> S = R
> %CPU = 0.0
> %MEM = 0.0

cat /proc/$PID/stat ; sleep 3; cat /proc/$PID/stat ?
cat /proc/sched_debug; sleep 3 ; cat /proc/sched_debug

and also cat /proc/$PID/stat taken when this task still looks 'sane' :-/

Do you mean that only SCHED_NORMAL tasks can't run on this cpu or RT
tasks of high prio as well (so that maybe the scheduler is in
inconsistent state) ?
If the latter, the watchdog should have triggered after a while (if
enabled), I guess.

>
> Here's the corresponding trace from sysrq+t:
>
>  [<ffffffff8022fdb7>] ? try_to_wake_up+0x77/0x200
>  [<ffffffff8023573d>] __cond_resched+0x2d/0x60
>  [<ffffffff804ddce1>] _cond_resched+0x31/0x40
>  [<ffffffff804ddd24>] wait_for_common+0x34/0x170
>  [<ffffffff8022fdb7>] ? try_to_wake_up+0x77/0x200
>  [<ffffffff804ddec8>] wait_for_completion+0x18/0x20
> [ ... ]

does a stack trace always look like this?


-- 
Best regards,
Dmitry Adamushko
