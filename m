Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbXJCOz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbXJCOz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbXJCOzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:55:51 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:46820 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750818AbXJCOzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:55:50 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 10:55:49 EDT
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: a.p.zijlstra@chello.nl, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
In-Reply-To: <200710032319.ABF69743.VJQMLHFOFOtFOS@I-love.SAKURA.ne.jp>
References: <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
	 <20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	 <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	 <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	 <1191417864.5599.2.camel@lappy>
	 <200710032319.ABF69743.VJQMLHFOFOtFOS@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 10:35:17 -0400
Message-Id: <1191422117.1553.8.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-03 at 23:19 +0900, Tetsuo Handa wrote:
> Hello.
> 
> Thank you for pointing out.
> 
> Peter Zijlstra wrote:
> > > Currently, TOMOYO Linux avoids read_lock, on the assumption that
> > > (1) First, ptr->next is initialized with NULL.
> > > (2) Later, ptr->next is assigned non-NULL address.
> > > (3) Assigning to ptr->next is done atomically.
> >  (4) wmb after asigning ptr->next
> >  (5) rmb before reading ptr->next
> Excuse me, but I didn't understand why (4) and (5) are needed.
> 
> append_function() {
> 
>   down(semaphore_for_write_protect);
>   ...
>   ptr = head;
>   while (ptr->next) ptr = ptr->next;
>   ptr->next = new_entry;
>   ...
>   up(semaphore_for_write_protect);
> 
> }

It seems to me that this function alone is a reason to argue against
using a singly linked list. I know your patch doesn't actually contain
this as a function but it does use the same logic to append to your
lists. Does the overhead of the second pointer that the regular list
head uses outweigh the O(1) insertion and deletion it provides
(especially in your case)? I know domain transitions are rare but why
use something with O(N) insertion? This could be one reason why there
isn't an slist already in list.h

Dave Quigley

