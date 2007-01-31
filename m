Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbXAaCEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbXAaCEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbXAaCEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:04:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:39046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258AbXAaCEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:04:32 -0500
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <patchbomb.1170193181@tetsuo.zabbo.net>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 13:04:04 +1100
Message-Id: <1170209044.26655.364.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - We would now have some measure of task_struct concurrency.  Read that twice,
> it's scary.  As two fibrils execute and block in turn they'll each be
> referencing current->.  It means that we need to audit task_struct to make sure
> that paths can handle racing as its scheduled away.  The current implementation
> *does not* let preemption trigger a fibril switch.  So one only has to worry
> about racing with voluntary scheduling of the fibril paths.  This can mean
> moving some task_struct members under an accessor that hides them in a struct
> in task_struct so they're switched along with the fibril.  I think this is a
> manageable burden.

That's the one scaring me in fact ... Maybe it will end up being an easy
one but I don't feel too comfortable... we didn't create fibril-like
things for threads, instead, we share PIDs between tasks. I wonder if
the sane approach would be to actually create task structs (or have a
pool of them pre-created sitting there for performances) and add a way
to share the necessary bits so that syscalls can be run on those
spin-offs.

Ben.


