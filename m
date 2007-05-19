Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbXESWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbXESWNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760457AbXESWNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:13:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853AbXESWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:13:16 -0400
Date: Sat, 19 May 2007 15:09:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-Id: <20070519150934.bdabc9b5.akpm@linux-foundation.org>
In-Reply-To: <20070519181501.GC19966@holomorphy.com>
References: <20070518040854.GA15654@wotan.suse.de>
	<Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
	<20070519012530.GB15569@wotan.suse.de>
	<20070519181501.GC19966@holomorphy.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 11:15:01 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> Much the same holds for the atomic_t's; 32 + PAGE_SHIFT is
> 44 bits or more, about as much as is possible, and one reference per
> page per page is not even feasible. Full-length atomic_t's are just
> not necessary.

You can overflow a page's refcount by mapping it 4G times.  That requires
32GB of pagetable memory.  It's quite feasible with remap_file_pages().

