Return-Path: <linux-kernel-owner+w=401wt.eu-S1762537AbXKPSIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537AbXKPSIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbXKPSIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:08:43 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:39929 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbXKPSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:08:42 -0500
Date: Fri, 16 Nov 2007 10:08:41 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 4/4] first use of sys_indirect system call
In-Reply-To: <200711151822.lAFIMVnJ028596@devserv.devel.redhat.com>
Message-ID: <alpine.DEB.0.9999.0711161003310.15441@twinlark.arctic.org>
References: <200711151822.lAFIMVnJ028596@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

you know... i understand the need for FD_CLOEXEC -- in fact i tried 
petitioning for CLOEXEC options to all the fd creating syscalls something 
like 7 years ago when i was banging my head against the wall trying to 
figure out how to thread apache... but even still i'm not convinced that 
extending every system call which creates an fd is the way to do this.  
honestly i think there should be a per-task flag which indicates whether 
fds are by default F_CLOEXEC or not.  my reason:  third party libraries.

i can control all my own code in a threaded program, but i can't control 
all the code which is linked in.  fds are going to leak.

if i set a per task flag then the only thing which would break are third 
party libraries which use fork/exec and aren't aware they may need to 
unset F_CLOEXEC.  personally i'd rather break that than leak fds to 
another program.

but hey i'm happy to see this sort of thing is finally being fixed, 
thanks.

-dean
