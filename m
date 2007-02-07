Return-Path: <linux-kernel-owner+w=401wt.eu-S933272AbXBGApR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbXBGApR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933274AbXBGApQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:45:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:44402 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272AbXBGApP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:45:15 -0500
Date: Tue, 6 Feb 2007 16:44:43 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070207004443.GE32307@ca-server1.us.oracle.com>
Mail-Followup-To: Davide Libenzi <davidel@xmailserver.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com> <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com> <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org> <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com> <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com> <20070206233907.GW32307@ca-server1.us.oracle.com> <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com> <20070207000626.GC32307@ca-server1.us.oracle.com> <Pine.LNX.4.64.0702061612220.19136@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702061612220.19136@alien.or.mcafeemobile.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 04:23:52PM -0800, Davide Libenzi wrote:
> To how many "sessions" those 1000 *parallel* I/O operations refer to? 
> Because, if you batch them in an async fashion, they have to be parallel.

	They're independant.  Of course they have to be parallel, that's
what I/O wants.

> Without the per-async operation status code, you'll need to wait a result 
> *for each* submitted syscall, even the ones that completed syncronously.

	You are right, but it's more efficient in some cases.

> Open questions are:
> 
> - Is the 1000 *parallel* syscall vectored submission case common?

	Sure is for I/O.  It's the majority of the case.  If you have
1000 blocks to send out, you want them all down at the request queue at
once, where they can merge.

> - Is it more expensive to forcibly have to wait and fetch a result even 
>   for in-cache syscalls, or it's faster to walk the submission array?

	Not everything is in-cache.  Databases will be doing O_DIRECT
and will expect that 90% of their I/O calls will block.  Why should they
have to iterate this list every time?  If this is the API, they *have*
to.  If there's an efficient way to get "just the ones that didn't
block", then it's not a problem.

Joel


-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd@loiosh.kei.com)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
