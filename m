Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZJHW2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZJHW2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 18:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbZJHW2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 18:28:08 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1853 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbZJHW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 18:28:07 -0400
Message-ID: <4ACE674E.30403@hp.com>
Date: Thu, 08 Oct 2009 18:27:26 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH] kmap_atomic_push
References: <1255016123.17055.17.camel@laptop>  <20091008155344.GA11727@elte.hu> <1255019362.26976.311.camel@twins> <alpine.LFD.2.01.0910080945230.3432@localhost.localdomain> <Pine.LNX.4.64.0910081850270.4553@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910081850270.4553@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So if I understand this correctly, the sequence:

in = kmap_atomic(inpage, KM_USER1);

out = kmap_atomic(outpage, KM_USER0);

kunmap_atomic(in, KM_USER1);

in = kmap_atomic(next_inpage, KM_USER1);

is now illegal with this patch, which breaks code
I am testing now for btrfs.

My code does this because the in/out are zlib inflate
and the in/out run at different rates.

OK, the code is not submitted yet and I can redesign the
code using a temp buffer for out and copy every byte or
use kmap(), either of them at some performance cost.

I'm just pointing out that there are cases where this
stack design puts an ugly restriction on use.

So if I understand this right, I don't love the patch (:

jim
