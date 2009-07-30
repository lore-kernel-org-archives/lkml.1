Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZG3VOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZG3VOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZG3VOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:14:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZG3VOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:14:54 -0400
Date: Thu, 30 Jul 2009 17:14:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Patch RFC 21/37] affs: use semaphore_init instead of
	init_MUTEX
Message-ID: <20090730211453.GB14722@infradead.org>
References: <20090726081459.455111897@linutronix.de> <20090726081556.004474377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090726081556.004474377@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 08:18:45AM -0000, Thomas Gleixner wrote:
> The usage of these "mutex" is non obvious and probably a completion
> in some places. Make it them semaphores.

Except for the obsfucation by the wrappers it's clearly obvious that
these are plain binary mutexes, so they should be converted.  Note that
this will trigger some lockdep warnings as we sometimes hold the same
lock for parent and child.  Maybe we can use this as a check if any
users of affs are left :)

