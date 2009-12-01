Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZLAGcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZLAGcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZLAGce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:32:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZLAGcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:32:33 -0500
Date: Mon, 30 Nov 2009 22:32:01 -0800
From: Chris Wright <chrisw@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-ID: <20091201063201.GD14368@x200.localdomain>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
 <Pine.LNX.4.64.0911241640590.25288@sister.anvils>
 <20091130094616.8f3d94a7.kamezawa.hiroyu@jp.fujitsu.com>
 <20091130120705.GD30235@random.random>
 <20091201093945.8c24687f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201093945.8c24687f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki (kamezawa.hiroyu@jp.fujitsu.com) wrote:
> Hmm. Can KSM coalesce 10000+ of pages to a page ?

Yes.  The zero page is a prime example of this.

> In such case, lru
> need to scan 10000+ ptes with 10000+ anon_vma->lock and 10000+ pte locks
> for reclaiming a page.

Would likely be a poor choice too.  With so many references it's likely
to be touched soon and swapped right back in.

thanks,
-chris
