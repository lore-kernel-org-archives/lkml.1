Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbYDCTX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbYDCTX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYDCTXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:23:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55890 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667AbYDCTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:23:19 -0400
Date: Thu, 3 Apr 2008 12:20:41 -0700 (PDT)
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
Subject: Re: EMM: disable other notifiers before register and unregister
In-Reply-To: <20080403151908.GB9603@duo.random>
Message-ID: <Pine.LNX.4.64.0804031215050.7480@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com>
 <20080402220148.GV19189@duo.random> <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com>
 <20080402221716.GY19189@duo.random> <Pine.LNX.4.64.0804021821230.639@schroedinger.engr.sgi.com>
 <20080403151908.GB9603@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Andrea Arcangeli wrote:

> My attempt to fix this once and for all is to walk all vmas of the
> "mm" inside mmu_notifier_register and take all anon_vma locks and
> i_mmap_locks in virtual address order in a row. It's ok to take those
> inside the mmap_sem. Supposedly if anybody will ever take a double
> lock it'll do in order too. Then I can dump all the other locking and

What about concurrent mmu_notifier registrations from two mm_structs 
that have shared mappings? Isnt there a potential deadlock situation?

> faults). So it should be ok to take all those locks inside the
> mmap_sem and implement a lock_vm(mm) unlock_vm(mm). I'll think more
> about this hammer approach while I try to implement it...

Well good luck. Hopefully we will get to something that works.

