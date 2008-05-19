Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYESIa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYESIa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYESIaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:30:18 -0400
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:1374 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbYESIaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:30:17 -0400
Subject: Re: [PATCH] selinux: reorder inode_security_struct to increase
	objs/slab on 64bit
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: James Morris <jmorris@namei.org>
Cc: sds@tycho.nsa.gov, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Xine.LNX.4.64.0805190916290.12130@us.intercode.com.au>
References: <1211110377.3021.8.camel@castor.localdomain>
	 <Xine.LNX.4.64.0805190916290.12130@us.intercode.com.au>
Content-Type: text/plain
Date: Mon, 19 May 2008 09:21:18 +0100
Message-Id: <1211185278.2986.8.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-19 at 09:18 +1000, James Morris wrote: 
> On Sun, 18 May 2008, Richard Kennedy wrote:
> 
> > reorder inode_security_struct to remove padding on 64 bit builds
> >     
> > size reduced from 72 to 64 bytes increasing objects per slab to 64.
> >         
> > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> Thanks, applied to 
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm
> 
> (Although I see a reduction from 164 to 160 bytes).
> 
> 
> - James

In that case I think you've got all the lock & mutex debugging turned
on :)
CONFIG_DEBUG_MUTEXES & CONFIG_DEBUG_LOCK_ALLOC will add a lot to the
mutex directly.

CONFIG_GENERIC_LOCKBREAK, CONFIG_DEBUG_SPINLOCK &
CONFIG_DEBUG_LOCK_ALLOC will each grow the spinlock contained in the
mutex.

However, I'm seeing all structures packed to size of 8n -- so I'd never
get a sizeof 164. Maybe that's just a platform/compiler difference ?
I'm running on AMD 64 & gcc 4.1.2


Richard



