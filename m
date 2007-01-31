Return-Path: <linux-kernel-owner+w=401wt.eu-S1161017AbXAaUUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161017AbXAaUUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161020AbXAaUUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:20:45 -0500
Received: from rgminet02.oracle.com ([148.87.113.119]:64179 "EHLO
	rgminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161017AbXAaUUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:20:44 -0500
Date: Wed, 31 Jan 2007 12:13:45 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Message-ID: <20070131201345.GJ32307@ca-server1.us.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Zach Brown <zach.brown@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org> <45C02AFA.4080501@yahoo.com.au> <Pine.LNX.4.64.0701302153520.3611@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701302153520.3611@woody.linux-foundation.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 10:06:48PM -0800, Linus Torvalds wrote:
> (Sadly, some of the people who really _use_ AIO are the database people, 
> and they really only care about a particularly stupid and trivial case: 
> pure reads and writes. A lot of other loads care about much more complex 
> things: filename lookups etc, that traditional AIO cannot do at all, and 
> that you really want something more thread-like for. But those other loads 
> get kind of swamped by the DB needs, which are might tighter and trivial 
> enough that you don't "need" a real thread for them).

	While certainly not an exhaustive list, DB people love their
reads and writes, but are pining for network reads and writes.  They
also are very excited about async poll(), connect(), and accept().  One
of the big problems today is that you can either sleep for your I/O in
io_getevents() or for your connect()/accept() in poll()/epoll(), but
there is nowhere you can sleep for all of them at once.  That's why the
aio list continually proposes aio_poll() or returning aio events
via epoll().
	Fibril based syscalls would allow async connect()/accept() and
the rest of networking, plus one stop shopping for completions.

Joel


-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
