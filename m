Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZFATxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZFATxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZFATxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:53:41 -0400
Received: from mta.netezza.com ([12.148.248.132]:55936 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753827AbZFATxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:53:41 -0400
Subject: Re: [PATCH] coredump: Retry writes where appropriate
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20090601200232.078aacbb@lxorguk.ukuu.org.uk>
References: <1243748019.7369.319.camel@homebase.localnet>
	 <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	 <20090601161234.GA10486@redhat.com>
	 <1243877766.8547.38.camel@psmith-ubeta.netezza.com>
	 <20090601184934.1fc54411@lxorguk.ukuu.org.uk>
	 <1243881544.8547.66.camel@psmith-ubeta.netezza.com>
	 <20090601200232.078aacbb@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Mon, 01 Jun 2009 15:51:39 -0400
Message-Id: <1243885899.8547.95.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jun 2009 19:51:40.0131 (UTC) FILETIME=[616DAB30:01C9E2F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 20:02 +0100, Alan Cox wrote:
> > If a program seems to be unresponsive the user could ^C, without
> > realizing that it was really dumping core.  Now when they are asked to
> > produce the core so the problem can be debugged, they can't do it.  Or,
> 
> and get their prompt back, which is probably why they are banging ^C. If
> they didn't want their prompt back at that point they'd still be
> wondering why nothing was occuring at the point it said (core dumped)

True.  My concern is that non-interactive, non-user controlled processes
seem to be getting thrown out with the bathwater here in the search for
the ultimate ease-of-use for interactive users.  SIGINT is not just a
user signal.

If it's interactive, can't the user ^Z (SIGSTOP) the process being
dumped, then kill -9 %1?  Does SIGSTOP stop a process that's dumping
core?  If this works it's not as simple as ^C, but I find myself doing
that all the time for processes which are catching SIGINT, as Oleg
points out.

Saying that SIGSTOP stops a core dump, SIGCONT continues it, SIGKILL
cancels it, and everything else is ignored would be just fine with me.

Yes, you need a shell with job control but... at some point we have to
just say it is what it is!  Core dumps are not just annoying time/disk
space wasters, they have real value; a good core dump can save tens of
thousands of dollars or more in support and development costs.  We need
(a way for) them to be reliable, even if it costs some interactive
ease-of-use.

Anyway, that's my opinion :-)


