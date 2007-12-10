Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbXLJWQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbXLJWQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 17:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXLJWQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 17:16:10 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:58925 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbXLJWQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 17:16:09 -0500
Message-ID: <475DBA98.3000508@oracle.com>
Date: Mon, 10 Dec 2007 14:15:52 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Evgeniy Polyakov"@agminet03.oracle.com
Subject: Re: syslets v7: back to basics
References: <1196983219534-git-send-email-zach.brown@oracle.com> <475DAFE9.7040700@cfl.rr.com>
In-Reply-To: <475DAFE9.7040700@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I pulled from your tree to look over the patches, and noticed that it
> looks like several commits were merged improperly.  It looks like they
> were auto merged or something from an email, and the commit message
> contains the email headers, rather than just the commit message in the
> body.  This leads to the shortlog showing entries that start with
> "Return-Path:".

These are patches that guilt imported from email messages.  It didn't
strip the headers and I didn't care to.  I'll try to in the future, it
isn't a big deal.

> I was hoping to find at least some initial information on the overall
> design in Documentation/ but don't see any.  Have you written any yet
> that I could take a look at elsewhere maybe?

No, but it's coming.  I'd like to have some robust documentation so that
Ulrich can help me understand what more he'd need to support POSIX AIO
with syslets from glibc.

> Some of the things I was trying to figure out is does each syslet get
> its own stack,

Yes.  Each blocking operation has a thread that is performing the
operation synchronously.  The benefit is that the thread is only created
if the operation blocks.  If it doesn't block then it's a normal system
call invocation.  You don't have to manage threads and communicate the
arguments and results of system calls amongst threads for the case where
it never blocks.

> and schedule only at a few well defined points

No, every blocking point is considered a scheduling point.

> , and if
> so, would it then be fair to characterize them as kernel mode fibers?

I'm not sure what exactly you mean by kernel mode fibers (I can guess,
but I'd rather not).  From the answer of to the last question, though,
I'm going to guess that it might not be the most apt characterization.

- z

