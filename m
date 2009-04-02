Return-Path: <linux-kernel-owner+w=401wt.eu-S1764012AbZDBSJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764012AbZDBSJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762033AbZDBSIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:08:52 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:27444 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760773AbZDBSIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:08:51 -0400
Subject: Re: [PATCH]  Define a UNIQUE value for AS_UNEVICTABLE flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20090402095315.1098b6c3.akpm@linux-foundation.org>
References: <1238690835.7359.16.camel@lts-notebook>
	 <20090402095315.1098b6c3.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 02 Apr 2009 14:08:45 -0400
Message-Id: <1238695725.7359.29.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 09:53 -0700, Andrew Morton wrote:
> On Thu, 02 Apr 2009 12:47:15 -0400 Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > [PATCH] Define UNIQUE value of AS_UNEVICTABLE
> > 
> > Needed in 2.6.28, 2.6.29, ...
> > 
> > A new "address_space flag"--AS_MM_ALL_LOCKS--was defined to use the next
> > available AS flag while the Unevictable LRU was under development.  The
> > Unevictable LRU was using the same flag and "no one" noticed.  Current 
> > mainline, since 2.6.28, has same value for two symbolic flag names.
> 
> argh.
> 
> What are the user-observable effects of the bug, and why didn't anyone
> notice it until now?


Well, AS_MM_ALL_LOCKS seems to be used for mmu notifiers.  So, I expect
I've never enabled it.  However, I think that if it got set, all of the
pages in all of the vmas that had it set will appear to be unevictable.
This would only matter if/when one tried to reclaim/evict them.  The
pages would probably get stranded on the unevictable lru [until freed]
in that case as there would be no scan to rescue them when
AS_MM_ALL_LOCKS is cleared.

Not sure about the other way around:  flag set as AS_UNEVICTABLE and
code examining AS_MM_ALL_LOCKS sees it...



