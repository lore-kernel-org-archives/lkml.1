Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbZDUDPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbZDUDPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZDUDPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:15:10 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:33944 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZDUDPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:15:09 -0400
Date: Tue, 21 Apr 2009 08:44:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: fix pageref leak in do_swap_page()
Message-ID: <20090421031419.GB30001@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johannes Weiner <hannes@cmpxchg.org> [2009-04-20 22:24:43]:

> By the time the memory cgroup code is notified about a swapin we
> already hold a reference on the fault page.
> 
> If the cgroup callback fails make sure to unlock AND release the page
> or we leak the reference.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>

Seems reasonable to me, could you make the changelog more verbose and
mention that lookup_swap_cache() gets a reference to the page and we
need to release the extra reference.

BTW, have you had any luck reproducing the issue? How did you catch
the problem?

-- 
	Balbir
