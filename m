Return-Path: <linux-kernel-owner+w=401wt.eu-S933661AbYBCNmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbYBCNmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 08:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbYBCNmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 08:42:04 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43729 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750708AbYBCNmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 08:42:03 -0500
Date: Sun, 3 Feb 2008 07:41:58 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 0/4] [RFC] EMMU Notifiers V5
Message-ID: <20080203134158.GB3875@sgi.com>
References: <20080201050439.009441434@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201050439.009441434@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great news!  I have taken over Dean's xpmem patch set while he is on
sabbatical.  Before he left, he had his patch mostly working on top of
this patch set.  We had one deadlock.  I have coded for that specific
deadlock and xpmem now passes a simple grant/attach/fault/fork/unmap/map
test.

After analyzing it, I believe we still have a nearly related deadlock
which will require some refactoring of code.  I am certain that the
same mechanism I used for this deadlock break will work in that case,
but it will require too many changes for me to finish this weekend.

For our customer base, this case, in the past, has resulted in termination
of the application and our MPI library specifically states that this
mode of operation is not permitted, so I think we will be able to pass
their regression tests.  I will need to coordinate that early next week.

The good news, at this point, Christoph's version 5 of the mmu_notifiers
appears to work for xpmem.  The mmu_notifier call-outs where the
in_atomic flag is set still result in a BUG_ON.  That is not an issue
for our normal customer as our MPI already states this is not a valid
mode of operation and provides means to avoid those types of mappings.

Thanks,
Robin
