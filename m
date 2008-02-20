Return-Path: <linux-kernel-owner+w=401wt.eu-S1762396AbYBTOmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762396AbYBTOmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYBTOl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:41:59 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52824 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbYBTOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:41:59 -0500
Date: Wed, 20 Feb 2008 08:41:55 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v6
Message-ID: <20080220144155.GI11391@sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220103942.GU7128@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 11:39:42AM +0100, Andrea Arcangeli wrote:
> XPMEM simply can't use RCU for the registration locking if it wants to
> schedule inside the mmu notifier calls. So I guess it's better to add

Whoa there.  In Christoph's patch, we did not use rcu for the list.  It
was a simple hlist_head.  The list manipulations were done under
down_write(&current->mm->mmap_sem) and would therefore not be racy.  All
the callout locations are already acquiring the mmap_sem at least
readably, so we should be safe.  Maybe I missed a race somewhere.

Thanks,
Robin
