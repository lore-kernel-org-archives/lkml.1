Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZLDSxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZLDSxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZLDSxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:53:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZLDSxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:53:07 -0500
Date: Fri, 4 Dec 2009 19:53:03 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Chris Wright <chrisw@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-ID: <20091204185303.GL28697@random.random>
References: <20091202125501.GD28697@random.random>
 <20091203134610.586E.A69D9226@jp.fujitsu.com>
 <20091204135938.5886.A69D9226@jp.fujitsu.com>
 <20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
 <20091204171640.GE19624@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204171640.GE19624@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 09:16:40AM -0800, Chris Wright wrote:
> That's why I mentioned the page of zeroes as the prime example of
> something with a high mapcount that shouldn't really ever be evicted.

Just a nitpick, "never" is too much, it should remain evictable if
somebody halts all VM from monitor and starts a workloads that fills
RAM and runs for a very prolonged time pushing all VM into swap. This
is especially true if we stick to the below approach and it isn't
just 1 page in high-sharing.

> It's a somewhat special case, but wouldn't it be useful to have a generic
> method to recognize this kind of sharing since it's a generic issue?

Agreed.
