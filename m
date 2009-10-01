Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZJAUfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZJAUfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbZJAUfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:35:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:29879 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbZJAUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:35:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tkZstLfviX/pqK1YYjU4ziWZYzLP0+s91JFtKcWMiqeqZXKNRJdp/8RvDh3r1KB/o
	9fnm3cWIZzK/+Mh7RKhEA==
Date: Thu, 1 Oct 2009 13:35:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suresh Jayaraman <sjayaraman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 01/31] mm: serialize access to min_free_kbytes
In-Reply-To: <1254405871-15687-1-git-send-email-sjayaraman@suse.de>
Message-ID: <alpine.DEB.1.00.0910011330430.27559@chino.kir.corp.google.com>
References: <1254405871-15687-1-git-send-email-sjayaraman@suse.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Suresh Jayaraman wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl> 
> 
> There is a small race between the procfs caller and the memory hotplug caller
> of setup_per_zone_wmarks(). Not a big deal, but the next patch will add yet
> another caller. Time to close the gap.
> 

By "next patch," you mean "mm: emegency pool" (patch 08/31)?

If so, can't you eliminate var_free_mutex entirely from that patch and 
take min_free_lock in adjust_memalloc_reserve() instead?

 [ __adjust_memalloc_reserve() would call __setup_per_zone_wmarks()
   under lock instead, now. ]
