Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0BDEjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:39:36 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50516 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab0BDEjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:39:33 -0500
Date: Thu, 4 Feb 2010 13:39:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: George Spelvin <linux@horizon.com>
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100204043923.GC451@linux-sh.org>
References: <20100203235644.3084.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203235644.3084.qmail@science.horizon.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 06:56:44PM -0500, George Spelvin wrote:
> > Apart from that, flush_dcache_page() doesn't have any data flow
> > information. Optimisations could be done on ARM if we know that the
> > kernel only intends to read from a page (no flushing necessary with a
> > non-aliasing D-cache).
> 
> Already done in flush_dcache_page().  If possible (uniprocessor), it just
> flags the page as PG_dcache_dirty, and defers the actual flush operation
> until it's mapped somewhere else (either a virtual alias or executable).
> 
Try reading the thread again, as you seem to have missed the point
completely. The issue isn't with lazy dcache writeback, the issue is that
flush_dcache_page() is a bit of a sledgehammer for cases when directional
information is available. The DMA mapping operations conversely are aware
of data flow and optimize accordingly.

Additionally, with something like a flush_dcache_range() it's possible
to optimize for large ranges as opposed to page-at-a-time looping for
anything that needs to flag PG_dcache_dirty on a bulk group of pages.
