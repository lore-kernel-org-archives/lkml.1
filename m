Return-Path: <linux-kernel-owner+w=401wt.eu-S1946099AbXDEIcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946099AbXDEIcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946090AbXDEIcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:32:48 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946099AbXDEIcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:32:45 -0400
Date: Thu, 5 Apr 2007 01:32:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-Id: <20070405013225.4135b76d.akpm@linux-foundation.org>
In-Reply-To: <4614A7B1.60808@redhat.com>
References: <46128051.9000609@redhat.com>
	<p73648dz5oa.fsf@bingen.suse.de>
	<46128CC2.9090809@redhat.com>
	<20070403172841.GB23689@one.firstfloor.org>
	<20070403125903.3e8577f4.akpm@linux-foundation.org>
	<4612B645.7030902@redhat.com>
	<20070403202937.GE355@devserv.devel.redhat.com>
	<4614A5CC.5080508@redhat.com>
	<4614A7B1.60808@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 03:39:29 -0400 Rik van Riel <riel@redhat.com> wrote:

> Rik van Riel wrote:
> 
> > MADV_DONTNEED, unpatched, 1000 loops
> > 
> > real    0m13.672s
> > user    0m1.217s
> > sys     0m45.712s
> > 
> > 
> > MADV_DONTNEED, with patch, 1000 loops
> > 
> > real    0m4.169s
> > user    0m2.033s
> > sys     0m3.224s
> 
> I just noticed something fun with these numbers.
> 
> Without the patch, the system (a quad core CPU) is 10% idle.
> 
> With the patch, it is 66% idle - presumably I need Nick's
> mmap_sem patch.
> 
> However, despite being 66% idle, the test still runs over
> 3 times as fast!

Please quote the context switch rate when testing this stuff (I use vmstat 1).
I've seen it vary by a factor of 10,000 depending upon what's happening.

