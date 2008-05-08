Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYEHBQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYEHBQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbYEHBQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:16:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53805
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbYEHBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:16:13 -0400
Date: Wed, 07 May 2008 18:16:06 -0700 (PDT)
Message-Id: <20080507.181606.189746306.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805071705360.3024@woody.linux-foundation.org>
References: <20080507.163917.104000894.davem@davemloft.net>
	<alpine.LFD.1.10.0805071705360.3024@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 May 2008 17:06:29 -0700 (PDT)

> On Wed, 7 May 2008, David Miller wrote:
> > 
> > 1) If fork/clone/etc. errors, argument register %o2 is clobbered
> >    breaking syscall restart.
> 
> Wow. Do we actually restart fork/clone/etc? That sounds suspicious. Maybe 
> there is some other bug here?

do_fork() checks for signals, and returns -ERESTARTNOINTR right
before fully committing itself to the operation.
