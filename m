Return-Path: <linux-kernel-owner+w=401wt.eu-S1762293AbXITITk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293AbXITITk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762200AbXITITB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:19:01 -0400
Received: from mx12.go2.pl ([193.17.41.142]:48708 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762307AbXITIS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:18:59 -0400
Date: Thu, 20 Sep 2007 10:21:05 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070920082105.GB2065@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920072821.GA2065@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 09:28:21AM +0200, Jarek Poplawski wrote:
> On Thu, Sep 20, 2007 at 08:24:58AM +0200, Nadia Derbey wrote:
...
> > Before Calling msg_unlock() they call ipc_rcu_getref() that increments a 
> > refcount in the rcu header for the msg structure. This guarantees that 
> > the the structure won't be freed before they relock it. Once the 
> > structure is relocked by ipc_lock_by_ptr(), they do the symmetric 
> > operation i.e. ipc_rcu_putref().
...
> which seems to suggest "out" is an RCU protected pointer, so, I
> thought these refcounts were for something else. But, after looking
> at how it's used it turns out to be ~90% wrong: probably 9 out of 10
> places use refcouning around this, so, these rcu_read_locks() don't
> work here at all. So, probably I miss something again, but IMHO,
> these rcu_read_locks/unlocks could be removed here or in
...
...So I missed it again: after all this RCU protection works before
and after refcounting.

Sorry,
Jarek P.
