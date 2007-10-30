Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXJ3PfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXJ3PfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXJ3Pep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:34:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60009 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755547AbXJ3Pen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:34:43 -0400
Date: Tue, 30 Oct 2007 15:35:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, RESEND] locks: fix possible infinite loop in posix
 deadlock detection
Message-ID: <20071030153556.3c6cfa29@the-village.bc.nu>
In-Reply-To: <20071030152002.GA21595@fieldses.org>
References: <20071017185157.GC3785@mvista.com>
	<20071018185759.GU3785@mvista.com>
	<20071026170750.GC13033@fieldses.org>
	<20071026224707.GO13033@fieldses.org>
	<20071028173136.GA16905@fieldses.org>
	<20071030152002.GA21595@fieldses.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 11:20:02 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> It's currently possible to send posix_locks_deadlock() into an infinite
> loop (under the BKL).
> 
> For now, fix this just by bailing out after a few iterations.  We may
> want to fix this in a way that better clarifies the semantics of
> deadlock detection.  But that will take more time, and this minimal fix
> is probably adequate for any realistic scenario, and is simple enough to
> be appropriate for applying to stable kernels now.
> 
> Thanks to George Davis for reporting the problem.
> 
> Cc: "George G. Davis" <gdavis@mvista.com>
> Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

Acked-by: Alan Cox <alan@redhat.com>

Its a good fix for now and I doubt any real world user has that complex a
locking pattern to break.
