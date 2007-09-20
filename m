Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbXITNYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbXITNYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXITNYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:24:23 -0400
Received: from mx2.go2.pl ([193.17.41.42]:52722 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751839AbXITNYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:24:22 -0400
Date: Thu, 20 Sep 2007 15:26:28 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070920132628.GC2796@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net> <46F270DA.5030101@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F270DA.5030101@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 03:08:42PM +0200, Nadia Derbey wrote:
...
> So, here is the ipc_lock_by_ptr() status:
> 1) do_msgsnd(), semctl_main(GETALL), semctl_main(SETALL) and find_undo() 
> call it inside a refcounting.
>   ==> no rcu read section needed.
> 
> 2) *_exit_ns(), ipc_findkey() and sysvipc_find_ipc() call it under the 
> ipc_ids mutex lock.
>   ==> no rcu read section needed.
> 
> 3) do_msgrcv() is the only path where ipc_lock_by_ptr() is not called 
> under refcounting
>   ==> rcu read section + some more checks needed once the spnlock is
>       taken.
> 
> So I completely agree with you: we might remove the rcu_read_lock() from 
> the ipc_lock_by_ptr() and explicitley  call it when needed (actually, it 
> is already explicitly called in do_msgrcv()).

Impossible!

I've to look at this once more in the evening (and try to recall
what I've seen yesterday and forgotten today...).

Cheers,
Jarek P.
