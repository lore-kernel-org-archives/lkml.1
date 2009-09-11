Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZIKGVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZIKGVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZIKGVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:21:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39147 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZIKGVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:21:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [GIT PULL] please pull ummunotify
Cc: kosaki.motohiro@jp.fujitsu.com, Roland Dreier <rdreier@cisco.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jsquyres@cisco.com, linux-rdma@vger.kernel.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AA9EAF7.5010401@inria.fr>
References: <adatyzahvbm.fsf@cisco.com> <4AA9EAF7.5010401@inria.fr>
Message-Id: <20090911151930.DB6B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 11 Sep 2009 15:21:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland Dreier wrote:
> >  > Can I this version already solved fork() + COW issue? if so, could you
> >  > please explain what happen at fork. Obviously RDMA point to either parent
> >  > or child page, not both. but Corrent COW rule is, first touch process
> >  > get copyed page and other process still own original page. I think it's 
> >  > unpecected behavior form RDMA.
> >
> > No, ummunotify doesn't really help that much with fork() + COW.  If a
> > parent forks and then touches pages that are actively in use for RDMA,
> > then of course they get COWed and RDMA goes to the wrong memory (from
> > the point of view of the parent).
> >   
> 
> My understanding of the code is that fork will end-up calling
> copy_page_range() on all VMA, and copy_page_range() calls
> mmu_notifier_invalidate_range_start() if  is_cow_mapping() is true,
> which should be the case here. So you should get some invalidate events
> on fork.

Worried...
Anybody haven't test fork() case yet???



