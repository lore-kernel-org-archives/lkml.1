Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192Ab0AFVh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0AFVh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932685Ab0AFVh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:37:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36640 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab0AFVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:37:26 -0500
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/7] Memory compaction core
From: Andi Kleen <andi@firstfloor.org>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
	<1262795169-9095-5-git-send-email-mel@csn.ul.ie>
Date: Wed, 06 Jan 2010 22:37:22 +0100
In-Reply-To: <1262795169-9095-5-git-send-email-mel@csn.ul.ie> (Mel Gorman's message of "Wed,  6 Jan 2010 16:26:06 +0000")
Message-ID: <87iqbeykx9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mel@csn.ul.ie> writes:


Haven't reviewed the full thing, but one thing I noticed below:

> +
> +	/*
> +	 * Isolate free pages until enough are available to migrate the
> +	 * pages on cc->migratepages. We stop searching if the migrate
> +	 * and free page scanners meet or enough free pages are isolated.
> +	 */
> +	spin_lock_irq(&zone->lock);

Won't that cause very long lock hold times on large zones?
Presumably you need some kind of lock break heuristic.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
