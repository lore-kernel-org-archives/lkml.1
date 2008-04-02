Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbYDBV5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbYDBV5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYDBV52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:57:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37599 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753812AbYDBV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:57:27 -0400
Date: Wed, 2 Apr 2008 14:54:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/9] EMM Notifier: The notifier calls
In-Reply-To: <20080402215334.GT19189@duo.random>
Message-ID: <Pine.LNX.4.64.0804021453350.31247@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
 <20080402215334.GT19189@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Andrea Arcangeli wrote:

> > Hmmm... Okay that is one solution that would just require a BUG_ON in the 
> > registration methods.
> 
> Perhaps you didn't notice that this solution can't work if you call
> range_begin/end not in the "current" context and try_to_unmap_cluster
> does exactly that for both my patchset and yours. Missing an _end is
> ok, missing a _begin is never ok.

If you look at the patch you will see a requirement of holding a 
writelock on mmap_sem which will keep out get_user_pages().
