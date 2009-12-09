Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZLIX5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZLIX5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbZLIX5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:57:32 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37704 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730AbZLIX5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:57:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 08:54:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-Id: <20091210085413.0fe4369e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091209161219.GV28697@random.random>
References: <20091202125501.GD28697@random.random>
	<20091203134610.586E.A69D9226@jp.fujitsu.com>
	<20091204135938.5886.A69D9226@jp.fujitsu.com>
	<20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
	<20091204171640.GE19624@x200.localdomain>
	<20091209094331.a1f53e6d.kamezawa.hiroyu@jp.fujitsu.com>
	<20091209161219.GV28697@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 17:12:19 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Dec 09, 2009 at 09:43:31AM +0900, KAMEZAWA Hiroyuki wrote:
> > cache-line ping-pong at fork beacause of page->mapcount. And KSM introduces
> > zero-pages which have mapcount again. If no problems in realitsitc usage of
> > KVM, ignore me.
> 
> The whole memory marked MADV_MERGEABLE by KVM is also marked
> MADV_DONTFORK, so if KVM was to fork (and if it did, if it wasn't for
> MADV_DONTFORK, it would also trigger all O_DIRECT vs fork race
> conditions too, as KVM is one of the many apps that uses threads and
> O_DIRECT - we try not to fork though but we sure did in the past), no
> slowdown could ever happen in mapcount because of KSM, all KSM pages
> aren't visibile by child.
> 
> It's still something to keep in mind for other KSM users, but I don't
> think mapcount is big deal if compared to the risk of triggering COWs
> later on those pages, in general KSM is all about saving tons of
> memory at the expense of some CPU cycle (kksmd, cows, mapcount with
> parallel forks etc...).
> 
Okay, thank you for kindlt explanation.

and sorry for noise.

Thanks,
-Kame

