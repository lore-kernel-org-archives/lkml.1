Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXHGSWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXHGSWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXHGSVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:21:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXHGSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:21:49 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: allow non root users to set io priority "idle" ?
To: Andi Kleen <andi@firstfloor.org>, dragoran <drago01@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 07 Aug 2007 20:21:29 +0200
References: <8P7nW-2Jc-7@gated-at.bofh.it> <8P7QZ-3AR-17@gated-at.bofh.it> <8P80L-3N5-25@gated-at.bofh.it> <8P8ak-3Yr-9@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IITgP-00019l-EN@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+sZmYkPQQQUIAmyPz/y8gR6QcEty6DzbQbax6
 +Sg+htPv3DuxZZG/2j3fqPM7Uz2tYlRv4lu6oIgIMNDJxSE456
 U6ViHEuwokQn6FMdV3JzA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

>> couldn't this be fixed by bumping idle tasks to middle while they hold a
> 
> Usually to high.

Then use the lowest non-idle priority. The result will not be more b0rken
than nice -n 19.

> But it's all complicated and hasn't been done consistently
> (there are real time mutexes in the -rt kernel for example,
> but there are lots of other locks and they have higher overhead too)
> and it's unclear we really want to do all this complexity anyways.

If you have an rt application, it will block normal tasks like a normal
task will block idle tasks. You need to handle that situation anyway.

> Also as I said the problem could then still happen in user space
> which then would all need to be fixed to handle PI too.

Don't do that then. If I ask an idle priority task, I should not expect an
answer unless the system is idle. And besides that, I should not depend on
an answer at all, since the task might be stuck while reading a NFS file
from that smoking and burning server.

> In some cases the relationship is also not as simple as a single
> lock. And for IO handling it would be likely quite hard.

As long as IO works correctly while having realtime tasks, there is no
problem, and if it doesn't work, it needs to be fixed anyway.

> I personally always found idle priorities quite dubious because
> even if they worked reliable for the CPU they will clear your cache/
> load your memory controller and impact all other programs because
> of this. And for the disk they will cause additional seeks which are
> also very costly.

A very-low-normal-priority tasks would cause all these effects anyway, but
it would do so more frequently.
-- 
Top 100 things you don't want the sysadmin to say:
74. I remember the last time I saw it do that...

Friﬂ, Spammer: jf@7eggert.dyndns.org rqfpzq@XhuRCfa.7eggert.dyndns.org
