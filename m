Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYDCU0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYDCU0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYDCUZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:25:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750757AbYDCUZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:25:51 -0400
Date: Thu, 3 Apr 2008 13:23:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: EMM: disable other notifiers before register and unregister
In-Reply-To: <Pine.LNX.4.64.0804031215050.7480@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0804031321260.8331@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com>
 <20080402220148.GV19189@duo.random> <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com>
 <20080402221716.GY19189@duo.random> <Pine.LNX.4.64.0804021821230.639@schroedinger.engr.sgi.com>
 <20080403151908.GB9603@duo.random> <Pine.LNX.4.64.0804031215050.7480@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Christoph Lameter wrote:

> > faults). So it should be ok to take all those locks inside the
> > mmap_sem and implement a lock_vm(mm) unlock_vm(mm). I'll think more
> > about this hammer approach while I try to implement it...
> 
> Well good luck. Hopefully we will get to something that works.

Another hammer to use may be the freezer from software suspend. With that 
you can get all tasks of a process into a definite state. Then take the 
mmap_sem writably. But then there is still try_to_unmap and friends that 
can race.


