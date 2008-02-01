Return-Path: <linux-kernel-owner+w=401wt.eu-S1765978AbYBADB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765978AbYBADB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 22:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYBADBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 22:01:45 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50131 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753150AbYBADBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:01:44 -0500
Date: Thu, 31 Jan 2008 19:01:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
In-Reply-To: <20080201024742.GD26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801311852140.6272@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com>
 <20080201023113.GB26420@sgi.com> <Pine.LNX.4.64.0801311838070.26594@schroedinger.engr.sgi.com>
 <20080201024742.GD26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Robin Holt wrote:

> Both xpmem and GRU have means of removing their context seperate from
> process termination.  XPMEMs is by closing the fd, I believe GRU is
> the same.  In the case of XPMEM, we are able to acquire the mmap_sem.
> For GRU, I don't think it is possible, but I do not remember the exact
> reason.

For any action initiated from user space you will not hold mmap sem. So 
you can call the unregister function. Then you need to do a 
synchronize_rcu before freeing the structures.

It is also possible to shut this down outside via f.e. a control thread. 
The control thread can acquire mmap_sem and then unregister the notifier.

Am I missing something?

