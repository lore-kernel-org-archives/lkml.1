Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbYDPTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbYDPTP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbYDPTPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:15:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33640 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757633AbYDPTPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:15:09 -0400
Date: Wed, 16 Apr 2008 12:15:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1 of 9] Lock the entire mm to prevent any mmu related
 operation to happen
In-Reply-To: <20080416190213.GK22493@sgi.com>
Message-ID: <Pine.LNX.4.64.0804161214170.14657@schroedinger.engr.sgi.com>
References: <patchbomb.1207669443@duo.random> <ec6d8f91b299cf26cce5.1207669444@duo.random>
 <20080416163337.GJ22493@sgi.com> <Pine.LNX.4.64.0804161134360.12296@schroedinger.engr.sgi.com>
 <20080416190213.GK22493@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008, Robin Holt wrote:

> On Wed, Apr 16, 2008 at 11:35:38AM -0700, Christoph Lameter wrote:
> > On Wed, 16 Apr 2008, Robin Holt wrote:
> > 
> > > I don't think this lock mechanism is completely working.  I have
> > > gotten a few failures trying to dereference 0x100100 which appears to
> > > be LIST_POISON1.
> > 
> > How does xpmem unregistering of notifiers work?
> 
> For the tests I have been running, we are waiting for the release
> callout as part of exit.

Some more details on the failure may be useful. AFAICT list_del[_rcu] is 
the culprit here and that is only used on release or unregister.


