Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbYEGQAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbYEGQAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYEGP74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:59:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38771 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756731AbYEGP7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:59:54 -0400
Date: Wed, 7 May 2008 10:59:48 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 02 of 11] get_task_mm
Message-ID: <20080507155948.GO18857@sgi.com>
References: <patchbomb.1210170950@duo.random> <c5badbefeee07518d9d1.1210170952@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5badbefeee07518d9d1.1210170952@duo.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can drop this patch.

This turned out to be a race in xpmem.  It "appeared" as if it were a
race in get_task_mm, but it really is not.  The current->mm field is
cleared under the task_lock and the task_lock is grabbed by get_task_mm.

I have been testing you v15 version without this patch and not
encountere the problem again (now that I fixed my xpmem race).

Thanks,
Robin

On Wed, May 07, 2008 at 04:35:52PM +0200, Andrea Arcangeli wrote:
> # HG changeset patch
> # User Andrea Arcangeli <andrea@qumranet.com>
> # Date 1210115127 -7200
> # Node ID c5badbefeee07518d9d1acca13e94c981420317c
> # Parent  e20917dcc8284b6a07cfcced13dda4cbca850a9c
> get_task_mm
