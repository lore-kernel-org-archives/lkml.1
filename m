Return-Path: <linux-kernel-owner+w=401wt.eu-S1030248AbXBGAGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030248AbXBGAGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030251AbXBGAGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:06:51 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:32500 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030248AbXBGAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:06:50 -0500
Date: Tue, 6 Feb 2007 16:06:26 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070207000626.GC32307@ca-server1.us.oracle.com>
Mail-Followup-To: Davide Libenzi <davidel@xmailserver.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com> <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com> <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com> <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org> <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com> <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com> <20070206233907.GW32307@ca-server1.us.oracle.com> <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 03:56:14PM -0800, Davide Libenzi wrote:
> Async syscall submissions are a _one time_ things. It's not like a live fd 
> that you can push inside epoll and avoid the multiple O(N) passes.
> First of all, the amount of syscalls that you'd submit in a vectored way 
> are limited. They do not depend on the total number of connections, but on 

	I regularly see apps that want to submit 1000 I/Os at once.
Every submit.  But it's all against one or two file descriptors.  So, if
you return to userspace, they have to walk all 1000 async_results every
time, just to see which completed and which didn't.  And *then* go wait
for the ones that didn't.  If they just wait for them all, they aren't
spinning cpu on the -EASYNC operations.
	I'm not saying that "don't return a completion if we can
non-block it" is inherently wrong or not a good idea.  I'm saying that
we need a way to flag them efficiently.

Joel

-- 

Life's Little Instruction Book #80

	"Slow dance"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
