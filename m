Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYDGFtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYDGFtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 01:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYDGFs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 01:48:57 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37825 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751088AbYDGFs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 01:48:56 -0400
Date: Sun, 6 Apr 2008 22:48:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/10] emm: notifier logic
In-Reply-To: <20080405005759.GH14784@duo.random>
Message-ID: <Pine.LNX.4.64.0804062246030.18148@schroedinger.engr.sgi.com>
References: <20080404223048.374852899@sgi.com> <20080404223131.469710551@sgi.com>
 <20080405005759.GH14784@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2008, Andrea Arcangeli wrote:

> > +	rcu_assign_pointer(mm->emm_notifier, e);
> > +	mm_unlock(mm);
> 
> My mm_lock solution makes all rcu serialization an unnecessary
> overhead so you should remove it like I already did in #v11. If it
> wasn't the case, then mm_lock wouldn't be a definitive fix for the
> race.

There still could be junk in the cache of one cpu. If you just read the 
new pointer but use the earlier content pointed to then you have a 
problem.

So a memory fence / barrier is needed to guarantee that the contents 
pointed to are fetched after the pointer.

