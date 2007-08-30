Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXH3KhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXH3KhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXH3Kg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:36:56 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39335 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbXH3Kg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:36:56 -0400
Date: Thu, 30 Aug 2007 11:36:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Daniel Drake <ddrake@brontes3d.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: speeding up swapoff
In-Reply-To: <m1d4x52zri.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0708301132470.26365@blonde.wat.veritas.com>
References: <1188394172.22156.67.camel@localhost>
 <Pine.LNX.4.64.0708291558480.27467@blonde.wat.veritas.com>
 <m1d4x52zri.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Eric W. Biederman wrote:
> 
> There is one other possibility.  Typically the swap code is using
> compatibility disk I/O functions instead of the best the kernel
> can offer.  I haven't looked recently but it might be worth just
> making certain that there isn't some low-level optimization or
> cleanup possible on that path.  Although I may just be thinking
> of swapfiles.

Andrew rewrote swapfile support in 2.5, making it use FIBMAP at
swapon time: so that in 2.6 swapfiles are as deadlock-free and
as efficient (unless the swapfile happens to be badly fragmented)
as raw disk partitions.

There's certainly scope for a study of I/O patterns in swapping,
it's hard to imagine that improvements couldn't be made (but also
easy to imagine endless disputes over different kinds of workload).
But most people would appreciate an improvement in active swapping,
and not care very much about the swapoff.

Regarding Daniel's use of swapoff: it's a very heavy sledgehammer
for cracking that nut, I strongly agree with those who have pointed
him to mlock and mlockall instead.

Hugh
