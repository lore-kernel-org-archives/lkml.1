Return-Path: <linux-kernel-owner+w=401wt.eu-S1764805AbYBADDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764805AbYBADDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 22:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYBADDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 22:03:44 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47259 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752446AbYBADDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:03:43 -0500
Date: Thu, 31 Jan 2008 19:03:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jack Steiner <steiner@sgi.com>
cc: Robin Holt <holt@sgi.com>, Andrea Arcangeli <andrea@qumranet.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
In-Reply-To: <20080201030104.GA29417@sgi.com>
Message-ID: <Pine.LNX.4.64.0801311901580.6272@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com>
 <20080201023113.GB26420@sgi.com> <Pine.LNX.4.64.0801311838070.26594@schroedinger.engr.sgi.com>
 <20080201030104.GA29417@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Jack Steiner wrote:

> I currently unlink the mmu_notifier when the last GRU mapping is closed. For
> example, if a user does a:
> 
>         gru_create_context();
>         ...
>         gru_destroy_context();
> 
> the mmu_notifier is unlinked and all task tables allocated
> by the driver are freed. Are you suggesting that I leave tables
> allocated until the task terminates??

You are in user space and calling into the kernel somehow. The 
mmap_sem is not held at that point so its no trouble to use the unregister 
function. After that wait for rcu and then free your tables.

> I assumed that I would need to use call_rcu() or synchronize_rcu()
> before the table is actually freed. That's still on my TODO list.

Right.

