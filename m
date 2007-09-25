Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbXIYRkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbXIYRkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXIYRj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:39:56 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34867 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbXIYRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:39:55 -0400
Date: Tue, 25 Sep 2007 13:39:27 -0400
From: Josef Sipek <jsipek@cs.sunysb.edu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, unionfs@filesystems.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm1
Message-ID: <20070925173927.GC352@filer.fsl.cs.sunysb.edu>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org> <20070925102637.79e1dc75.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925102637.79e1dc75.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 10:26:37AM -0700, Randy Dunlap wrote:
> On Tue, 25 Sep 2007 01:46:25 -0700 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm1/
> > 
> > - Various fixes against 2.6.23-rc7-mm1.
> > 
> > 
> >  git-unionfs.patch
> 
> in unionfs debug.c:
> 
> #if BITS_PER_LONG == 32
> #define POISONED_PTR		((void*) 0x5a5a5a5a)
> #elif BITS_PER_LONG == 64
> #define POISONED_PTR		((void*) 0x5a5a5a5a5a5a5a5a)
> #else
> #error Unknown BITS_PER_LONG value
> #endif /* BITS_PER_LONG != known */
> 
> 
> We try to keep all poison values in include/linux/poison.h so that
> when digging around for them, it's easier to locate the one in
> question.
 
Right. I didn't want to introduce this kind of ifdef, the 0x5a pattern is
also the same as POISON_INUSE. I guess, using the 32-bit poison value should
be good enough anyway.

> Also, on x86_64, the 64-bit version wants a L or UL suffix:
> 
> fs/unionfs/debug.c:96:30: warning: constant 0x5a5a5a5a5a5a5a5a is so big it is long
> fs/unionfs/debug.c:264:30: warning: constant 0x5a5a5a5a5a5a5a5a is so big it is long

Strange...I didn't get the warning when I compile tested; but it's valid.

Josef 'Jeff' Sipek.

-- 
Research, n.:
  Consider Columbus:
    He didn't know where he was going.
    When he got there he didn't know where he was.
    When he got back he didn't know where he had been.
    And he did it all on someone else's money.
