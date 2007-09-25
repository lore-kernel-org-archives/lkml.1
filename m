Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbXIYR1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbXIYR1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXIYR1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:27:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60950 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbXIYR1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:27:32 -0400
Date: Tue, 25 Sep 2007 10:26:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, unionfs@filesystems.org
Cc: linux-kernel@vger.kernel.org, jsipek@cs.sunysb.edu
Subject: Re: 2.6.23-rc8-mm1
Message-Id: <20070925102637.79e1dc75.randy.dunlap@oracle.com>
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 01:46:25 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm1/
> 
> - Various fixes against 2.6.23-rc7-mm1.
> 
> 
>  git-unionfs.patch

in unionfs debug.c:

#if BITS_PER_LONG == 32
#define POISONED_PTR		((void*) 0x5a5a5a5a)
#elif BITS_PER_LONG == 64
#define POISONED_PTR		((void*) 0x5a5a5a5a5a5a5a5a)
#else
#error Unknown BITS_PER_LONG value
#endif /* BITS_PER_LONG != known */


We try to keep all poison values in include/linux/poison.h so that
when digging around for them, it's easier to locate the one in
question.

Also, on x86_64, the 64-bit version wants a L or UL suffix:

fs/unionfs/debug.c:96:30: warning: constant 0x5a5a5a5a5a5a5a5a is so big it is long
fs/unionfs/debug.c:264:30: warning: constant 0x5a5a5a5a5a5a5a5a is so big it is long

---
~Randy
Phaedrus says that Quality is about caring.
