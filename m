Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbXFAOT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbXFAOT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759809AbXFAOS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:18:59 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1849 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520AbXFAOS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:18:58 -0400
Message-ID: <46602AC3.5060309@shadowen.org>
Date: Fri, 01 Jun 2007 15:18:43 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker II
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de> <465BECCC.5030001@shadowen.org> <20070531120753.GA2538@one.firstfloor.org> <20070531195917.GC31153@redhat.com>
In-Reply-To: <20070531195917.GC31153@redhat.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Thu, May 31, 2007 at 02:07:53PM +0200, Andi Kleen wrote:
>  > > Yeah, that is a very sensible idea.
>  > > 
>  > > > Possible further checks that might make sense:
>  > > > - panic() anywhere in drivers/* 
>  > > > - externs in .c files without asmlinkage
>  > > > - general checking that everything in a fully visible {} block is the right 
>  > > > indentation
>  > > > 
>  > 
>  > Here are some more warnings I would like to see:
>  > 
>  > - Warning for any spinlock/mutex definition that doesn't have a comment
>  > nearby (all locks ought to be documented) 
> 
> Also barriers. (Probably even moreso).

Both of these seem a pretty good idea.  Should be in version 0.03 which
I'll try and get to Andrew over the weekend.  Example reports from files
in 2.6.22-rc2-mm1 below.

-apw

spinlock_t definition without comment
FILE: lib/statistic.c:243:
+       spinlock_t lock;

struct mutex definition without comment
FILE: include/linux/kernelcapi.h:67:
+       struct mutex recv_mtx;

memory barrier without comment
FILE: fs/ext2/balloc.c:1250:
+       smp_rmb();
