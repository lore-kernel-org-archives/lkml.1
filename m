Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZCQSLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZCQSLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZCQSLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:11:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52446 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZCQSLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:11:17 -0400
Date: Tue, 17 Mar 2009 18:11:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Zhang Le <r0bertz@gentoo.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, alan@redhat.com
Subject: Re: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
Message-ID: <20090317181114.GW28946@ZenIV.linux.org.uk>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org> <20090316083457.GV28946@ZenIV.linux.org.uk> <20090317103744.GA2399@x200.localdomain> <20090317125346.GA22268@adriano.hkcable.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317125346.GA22268@adriano.hkcable.com.hk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 08:53:47PM +0800, Zhang Le wrote:
> > > way to go.
> > 
> > Except this bit:
> > 
> > fs/built-in.o: In function `proc_task_readdir':
> > compr_zlib.c:(.text+0x434b8): undefined reference to `__cmpdi2'
> > compr_zlib.c:(.text+0x434d4): undefined reference to `__cmpdi2'
> 
> Hi, I am sorry but I can't reproduce this.
> Are you sure this only happens after applying my patch?
> Would you please provide your fs/jffs2/compr_zlib.o and fs/proc/base.o?
> And what is your gcc version? I am using gcc 4.4 snapshot rev. 144705

The critical part is target architecture, not version...  switch on
long long ends up spewing library calls.  It's switch (pos) that
became switch (file->f_pos).  
