Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYLIRqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYLIRqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYLIRq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:46:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYLIRq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:46:27 -0500
Subject: Re: [RFC/PATCH] No get_user/put_user while holding mmap_sem in
 do_pages_stat?
From: Peter Zijlstra <peterz@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <493EA116.5020208@inria.fr>
References: <493B3179.7030204@inria.fr>
	 <20081206185050.544f67fc.akpm@linux-foundation.org>
	 <493BDBE6.9040600@inria.fr> <1228840546.12654.2.camel@twins>
	 <493EA116.5020208@inria.fr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Dec 2008 18:46:22 +0100
Message-Id: <1228844782.6978.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 17:47 +0100, Brice Goglin wrote:
> Peter Zijlstra wrote:
> > On Sun, 2008-12-07 at 15:21 +0100, Brice Goglin wrote:
> >   
> >> Andrew Morton wrote:
> >>     
> >>> Was lockdep able to tell you about this in any way?
> >>>   
> >>>       
> >> With CONFIG_PROVE_LOCKING (assuming that it's enough), it doesn't detect
> >> the problem for real. It just says "possible recursive locking detected"
> >> between do_page_fault and sys_move_pages.
> >>     
> >
> > That is real - how much more real do you need a description of a
> > recursive deadlock to be?
> >   
> 
> Well, it's a recursive down_read. It could be ok if we had the guarantee
> that nobody else would be doing down_write in the middle. lockdep only
> complained about this recursive down_read when there was a down_write
> actually causing the deadlock, but it didn't say anything about this
> down_write in the log.
> 
> It would be great if lockdep could say "recursive read-lock is
> deadlocking because this other guy (with its backtrace) took for write
> in the middle". I needed sysrq-t to get this info.

rwsem does not support recursive read-locks, so irrespective of write
side locks, its a bug.

