Return-Path: <linux-kernel-owner+w=401wt.eu-S933659AbXKOWeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbXKOWeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbXKOWem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:34:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbXKOWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:34:41 -0500
Date: Thu, 15 Nov 2007 14:33:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] sys_indirect system call
In-Reply-To: <473CC604.5050804@oracle.com>
Message-ID: <alpine.LFD.0.9999.0711151431220.4260@woody.linux-foundation.org>
References: <200711151641.lAFGfM8R024330@devserv.devel.redhat.com> <473CC604.5050804@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Zach Brown wrote:
> 
> I think we can use this to pass per-syscall syslet data to the
> scheduler.

Yes, I mentioned this to Ulrich as one of the things that would make 
sense.

Uli doesn't care that much about async syscalls, but I think that from a 
kernel standpoint, we'd want to use this same indirect call for async 
scheduling, rather than have two separate interfaces (because async 
scheduling will want to have all the same flags intefaces for 
open/socket/etc *too* and a doubly-indirect setup would be insanity!)

And it definitely fits the bill as a really simple syslet model for the 
trivial case of doing just single system calls asynchronously.

		Linus
