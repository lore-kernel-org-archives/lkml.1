Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbYEOLMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbYEOLMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYEOLMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:12:38 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:49085
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYEOLMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:12:38 -0400
Message-ID: <482C1AA2.20307@qumranet.com>
Date: Thu, 15 May 2008 14:12:34 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Nick Piggin <npiggin@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080508003838.GA9878@sgi.com> <200805132206.47655.nickpiggin@yahoo.com.au> <20080513153238.GL19717@sgi.com> <20080514041122.GE24516@wotan.suse.de> <20080514112625.GY9878@sgi.com> <20080515075747.GA7177@wotan.suse.de> <20080515110147.GD10126@sgi.com>
In-Reply-To: <20080515110147.GD10126@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> Then we need to deposit the information needed to do the invalidate.
>
> Lastly, we would need to interrupt.  Unfortunately, here we have a
> thundering herd.  There could be up to 16256 processors interrupting the
> same processor.  That will be a lot of work.  It will need to look up the
> mm (without grabbing any sleeping locks in either xpmem or the kernel)
> and do the tlb invalidates.
>
>   

You don't need to interrupt every time.  Place your data in a queue (you 
do support rmw operations, right?) and interrupt.  Invalidates from 
other processors will see that the queue hasn't been processed yet and 
skip the interrupt.

-- 
error compiling committee.c: too many arguments to function

