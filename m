Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZHCQxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZHCQxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZHCQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:53:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37404 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZHCQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:53:51 -0400
Date: Mon, 3 Aug 2009 18:53:15 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/12] ksm: move pages_sharing updates
Message-ID: <20090803165315.GH23385@random.random>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
 <Pine.LNX.4.64.0908031310060.16754@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908031310060.16754@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 01:11:00PM +0100, Hugh Dickins wrote:
> The pages_shared count is incremented and decremented when adding a node
> to and removing a node from the stable tree: easy to understand.  But the
> pages_sharing count was hard to follow, being adjusted in various places:
> increment and decrement it when adding to and removing from the stable tree.
> 
> And the pages_sharing variable used to include the pages_shared, then those
> were subtracted when shown in the pages_sharing sysfs file: now keep it as
> an exclusive count of leaves hanging off the stable tree nodes, throughout.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

If we stick to the subtraction semantics (that I think for users is
less intuitive as they need to understand more of the ksm code to
figure out what it means) sure ack...

I don't see the big deal of just printing total number of ksm pages in
stable tree, and the actual _total_ number of userland mappings that
are mapping those. The subtraction to see the actual sharing that is
the difference between the two numbers, can be done by the user
itself.

But then I'm fine if we stick to the substraction logic, this is a
minor detail, I just usually prefer "raw" values. (if removing the
inc/dec is beneficial at runtime as it seems then doing an addition
will provide the info I would find more intuitive in  a more efficient
way than before)

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
