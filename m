Return-Path: <linux-kernel-owner+w=401wt.eu-S1763226AbYAKXQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763226AbYAKXQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762157AbYAKXQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:16:43 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21405 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbYAKXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:16:42 -0500
X-IronPort-AV: E=Sophos;i="4.24,273,1196668800"; 
   d="scan'208";a="34518959"
To: "Vineet Gupta" <vineetg76@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Usage semantics of atomic_set ( )
X-Message-Flag: Warning: May contain useful information
References: <9f4f8abe0801111457t7535069ar1f98cc37d5cf8d40@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 11 Jan 2008 15:16:40 -0800
In-Reply-To: <9f4f8abe0801111457t7535069ar1f98cc37d5cf8d40@mail.gmail.com> (Vineet Gupta's message of "Fri, 11 Jan 2008 14:57:47 -0800")
Message-ID: <adahchk9cmf.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Jan 2008 23:16:41.0120 (UTC) FILETIME=[05F46200:01C854A8]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm trying to implement atomic ops for a CPU which has no inherent
 > support for Read-Modify-Write Ops. Instead of using a global spin lock
 > which protects all the atomic APIs, I want to use a spin lock per
 > instance of atomic_t. This works well when atomic_t is unitary and
 > statically initialized using ATOMIC_INIT (where I can reset the
 > spinlock_t as well). However if atomic_t var is embedded within a
 > bigger struct which is allocated dynamically how to I init the
 > embedded spin lock. atomic_set ( ) is the closest choice, however I
 > don't think it's current usage in kernel code qualifies it to be
 > "initializer only".

A simple way to handle this might be to use a separate array of
spinlocks and hash each atomic_t to one entry in the array.  You could
look in asm-parisc and arch/parisc to see an implementation of this
that is already in the kernel.

 - R.
