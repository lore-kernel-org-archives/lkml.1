Return-Path: <linux-kernel-owner+w=401wt.eu-S966880AbYD1TeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966880AbYD1TeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966746AbYD1Tdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:33:43 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40126 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966584AbYD1Tdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:33:40 -0400
Date: Mon, 28 Apr 2008 13:33:23 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/2] ia64: Migrate data off physical pages with correctable errors
Message-ID: <20080428193323.GA14990@parisc-linux.org>
References: <20080428192252.GA14629@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428192252.GA14629@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 02:22:52PM -0500, Russ Anderson wrote:
> 	There is always an issue of how agressive the code should be on
> 	migrating pages.  Should it migrate on the first correctable error,
> 	or wait for some threshold?  Reasonable people may disagree on the
> 	threshold and the "right" answer may be hardware specific.  The 
> 	decision making is confined to the cpe_migrate.c code.  It is
> 	currently set to migrate on the first correctable error.

I think the kernel code should do the migration ASAP.  But I think we
should have a list of 'bad' pages.  We could then have a badram driver
that userspace can talk to to find out which pages are bad, map those
pages into a badram process, do various tests on them, and return the
pages to the pool if they're determined to be 'good'.

I could also see badramd having a list of pages found to be bad
in previous boots and asking the badram driver to take them out of
circulation early in boot before they've been allocated.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
