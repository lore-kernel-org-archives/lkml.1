Return-Path: <linux-kernel-owner+w=401wt.eu-S1765456AbYAaIoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765456AbYAaIoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbYAaIoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:44:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49397 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbYAaIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:44:16 -0500
Subject: Re: [PATCH] mm: MADV_WILLNEED implementation for anonymous memory
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hugh@veritas.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       npiggin@suse.de, riel@redhat.com, mztabzr@0pointer.de, mpm@selenic.com
In-Reply-To: <20080130144049.73596898.akpm@linux-foundation.org>
References: <1201714139.28547.237.camel@lappy>
	 <20080130144049.73596898.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 09:44:00 +0100
Message-Id: <1201769040.28547.245.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 14:40 -0800, Andrew Morton wrote:
> On Wed, 30 Jan 2008 18:28:59 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Implement MADV_WILLNEED for anonymous pages by walking the page tables and
> > starting asynchonous swap cache reads for all encountered swap pages.
> 
> Why cannot this use (a perhaps suitably-modified) make_pages_present()?

Because make_pages_present() relies on page faults to bring data in and
will thus wait for all data to be present before returning.

This solution is async; it will just issue a read for the requested
pages and moves on.


