Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYEQSlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYEQSlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYEQSli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:41:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbYEQSlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:41:37 -0400
Date: Sat, 17 May 2008 11:41:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alistair John Strachan <alistair@devzero.co.uk>
cc: Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com,
       Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
In-Reply-To: <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805171139120.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org> <20080512164920.GE16217@kernel.dk> <200805171922.56272.alistair@devzero.co.uk>
 <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Linus Torvalds wrote:
> 
> Do this on the console (and having a serial console or working netconsole 
> is a wonderful thing to log it, because otherwise it will generally just 
> scroll off the screen), and trigger SysRQ-w. That dumps all blocked tasks 
> to the screen.

Another thing to try is to enable lock debugging, and have

	CONFIG_DEBUG_SPINLOCK=y
	CONFIG_DEBUG_MUTEXES=y
	CONFIG_DEBUG_LOCK_ALLOC=y
	CONFIG_PROVE_LOCKING=y
	CONFIG_LOCKDEP=y
	CONFIG_DEBUG_LOCKDEP=y

in your kernel .config file. It has performance implications, of course, 
but it can help debug incorrect locking much more quickly.

		Linus
