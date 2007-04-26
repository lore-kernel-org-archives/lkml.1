Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXDZIca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXDZIca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933605AbXDZIca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:32:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933604AbXDZIc2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:32:28 -0400
Date: Thu, 26 Apr 2007 01:30:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, maxextreme@gmail.com, gregkh@suse.de
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
Message-Id: <20070426013059.ce948f50.akpm@linux-foundation.org>
In-Reply-To: <200704260232.06909.arnd@arndb.de>
References: <20070423141123.GA21174@skybase>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<200704260232.06909.arnd@arndb.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 02:32:06 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 26 April 2007, Andrew Morton wrote:
> > It would be neat if someone could create and maintain a new
> > scripts/spot-common-mistakes.  Feed it a unified diff and it would complain
> > about newly-added code (and only newly-added code) which has busted
> > whitespace, adds new semaphores, adds new kernel_thread calls, etc, etc.
> 
> http://patchstylecheck.googlecode.com/svn/trunk/patchstylecheckemail.pl
> Might serve as a starting point for this. It doesn't have any semantic
> checks right now, but I guess they can be added.

oh man, every patch I review, every bug I fix, I dream of this.



Wishlist:

- wire it up to a robot which monitors all Linux mailing lists and sends
  machine-review comments back to originators.  This will be a huge win by
  eliminating so much stupid crap.  

- auto-detect wordwrapped and tab-replaced emails (oh glory)

- auto-detect code wider than 80-cols (swoon)

- auto-detect missing Signed-off-by:

- auto-check patch format and protocol, as per
  http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt and
  http://linux.yyz.us/patch-format.html

- teach it about semantics:

  - kthread instead of kernel_thread

  - mutexes instead of semaphores

  - the whole plethora of whitespace uckfuppednesses

  - needlessly-initialised-to-zero-static-variables

  - extern-decls-in-C

  - EXPORT_SYMBOL(foo) is placed immediately after foo()'s closing
    brace

    Hard to do?  Could just whine about all EXPORT_SYMBOL's which
    aren't immediately preceded by ^}$ or by ;$

  - new typedefs

  - use of uint32_t and friends

  - use of BUG_ON and BUG, frankly.  The thing's a damn pest.  Suggest
    WARN_ON+recover-from-it.

  - use of `if ((var = expr()))' and similar

  - large inlined functions?

  - braces around single statements (advanced topic ;))

  - StudlyCaps?

  - anything called "tmp" or "temp"

  - old-style struct initialisers

  - non-ascii characters(?)

  - lots more to come, I'm sure.

