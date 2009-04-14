Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZDNSMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZDNSMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbZDNSMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:12:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39243 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbZDNSMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:12:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Zach Brown <zach.brown@oracle.com>,
       Andy Grover <andy.grover@oracle.com>
Subject: Re: [RFC][PATCH v3 2/6] mm, directio: fix fork vs direct-io race (read(2) side IOW gup(write) side)
References: <20090414151204.C647.A69D9226@jp.fujitsu.com>
	<20090414151652.C64D.A69D9226@jp.fujitsu.com>
	<20090414152500.C65F.A69D9226@jp.fujitsu.com>
	<x49ab6jyyiy.fsf@segfault.boston.devel.redhat.com>
	<20090414175124.GC9809@random.random>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 14 Apr 2009 14:10:08 -0400
In-Reply-To: <20090414175124.GC9809@random.random> (Andrea Arcangeli's message
	of "Tue, 14 Apr 2009 19:51:24 +0200")
Message-ID: <x49hc0rxg1r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <aarcange@redhat.com> writes:

> On Tue, Apr 14, 2009 at 12:45:41PM -0400, Jeff Moyer wrote:
>> So, if you're continuously submitting async read I/O, you will starve
>> out the fork() call indefinitely.  I agree that you want to allow
>
> IIRC rwsem good enough to stop the down_read when a down_write is
> blocked. Otherwise page fault flood in threads would also starve any
> mmap or similar call. Still with this approach fork will start to hang

Really?  I don't actually see that in the code, have I missed it?

Cheers,
Jeff
