Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZA3Kpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZA3Kpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZA3Kp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:45:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:37792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZA3Kp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:45:27 -0500
Subject: Re: PFs on pages pinned with get_user_pages()
From: Peter Zijlstra <peterz@infradead.org>
To: Frank Mehnert <Frank.Mehnert@Sun.COM>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200901301134.07242.frank.mehnert@sun.com>
References: <200901290905.10966.frank.mehnert@sun.com>
	 <200901291703.35463.frank.mehnert@sun.com>
	 <1233245483.4495.106.camel@laptop>
	 <200901301134.07242.frank.mehnert@sun.com>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 11:45:21 +0100
Message-Id: <1233312321.4495.169.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 11:34 +0100, Frank Mehnert wrote:

> > Thing is, lock_page() and down_read() require to be able to schedule(),
> > so there's no way around that.
> >
> > So even if there was another way to disable scheduling, you'd still have
> > the same problem.
> 
> Yes, makes sense.
> 
> Back to my initial question: The problem arises for us because we depend
> on permanent mappings of memory which were
> 
>  - allocated with alloc_pages() or alloc_page()
>  - mapped into ring 3 with remap_pfn_range() and
>  - pinned with get_user_pages()
> 
> There are potential pagefaults when touching into these ring-3-mappings
> from ring 0. So I assume we could prevent such pagefaults if we access
> that memory from ring-0-mappings, right? Unfortunately, the space for
> ring-0-mappings (< 1GB) is smaller than userland (~ 3GB), at least on
> 32-bit systems.

if you only need to access one or two pages, you could kmap_atomic() the
actual pages from ring-0.

