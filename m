Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYHMRCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYHMRCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYHMRCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:02:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYHMRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:02:42 -0400
Date: Wed, 13 Aug 2008 10:01:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Vivek Goyal <vgoyal@redhat.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
 0) in kernel_kexec()
In-Reply-To: <20080813022712.4bea5fea.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808130958220.3462@nehalem.linux-foundation.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com> <20080813022712.4bea5fea.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Andrew Morton wrote:
>
> We don't need to create that local.  I queued this:

No, please don't. 

Just don't take this whole patch-series until it's cleaned up. There is 
absolutely no excuse for using xchg as a locking primitive. Nothing like 
this should be queued anywhere, it should be burned and the ashes should 
be scattered over the atlantic so that nobody will ever see them again.

F*ck me with a spoon, if you have to use xchg() to do a trylock, why the 
hell isn't the unlock sequence then

	smp_mb();
	var = 0;

instead? Not that that's really right either, but at least it avoids the 
_ridiculous_ crap. The real solution is probably to use a spinlock and 
trylock/unlock.

		Linus
