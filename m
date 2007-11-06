Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXKFLKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXKFLKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 06:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbXKFLKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 06:10:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38233
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757358AbXKFLKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 06:10:02 -0500
Date: Tue, 06 Nov 2007 03:10:01 -0800 (PST)
Message-Id: <20071106.031001.189578769.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: balbir@linux.vnet.ibm.com, kamalesh@linux.vnet.ibm.com,
       linuxppc-dev@ozlabs.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1-git15 Kernel build fails on powerpc - Unrecognized
 opcode: `dssall'
From: David Miller <davem@davemloft.net>
In-Reply-To: <1194346486.4066.13.camel@johannes.berg>
References: <47304343.2010709@linux.vnet.ibm.com>
	<661de9470711060246s3040f68drf0a6310aeec4e1e8@mail.gmail.com>
	<1194346486.4066.13.camel@johannes.berg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 06 Nov 2007 11:54:46 +0100

> 
> 
> > >   CHK     include/linux/compile.h
> > >   AS      arch/powerpc/kernel/swsusp_32.o
> > > arch/powerpc/kernel/swsusp_32.S: Assembler messages:
> > > arch/powerpc/kernel/swsusp_32.S:138: Error: Unrecognized opcode: `dssall'
> > > make[1]: *** [arch/powerpc/kernel/swsusp_32.o] Error 1
> > > make: *** [arch/powerpc/kernel] Error 2
> > >
> > 
> > Looks suspiciously like an altivec issue. Could you compile with make
> > V=1 and/or do a git bisect and see what broke?
> 
> Looks more like a toolchain issue to me.

Or, this is another instance of the "CFLAGS environment variable"
problem.

For a few days, the kbuild stuff would integrate any CFLAGS,
AFLAGS, etc. settings you might have set in your environment.
