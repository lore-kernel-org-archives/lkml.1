Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbXLKTto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbXLKTto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXLKTte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:49:34 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:44306 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbXLKTtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:49:33 -0500
Message-ID: <475EE9BE.3070909@oracle.com>
Date: Tue, 11 Dec 2007 11:49:18 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv5 0/5] sys_indirect system call
References: <200711210728.lAL7SoUM015040@devserv.devel.redhat.com>
In-Reply-To: <200711210728.lAL7SoUM015040@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Note that the sys_indirect system call takes an additional parameter which
> is for now forced to be zero.  This parameter is meant to enable the use
> of sys_indirect to create syslets, asynchronously executed system calls.
> This syslet approach is also the main reason for the interface in the form
> proposed here.

Can you talk more about how you imagined syslets working with
sys_indirect()?

I threw something together to test most of the machinery around the
actual argument passing.  It just added the syslet arguments to the union:

  http://lkml.org/lkml/2007/12/6/338
  http://lkml.org/lkml/2007/12/6/339

This obviously doesn't work because it's a perfectly reasonable thing to
want to provide the file_flags to some call as well as the syslet args
to perform that call in a syslet.

Then it butchers sys_indirect() itself:

  http://lkml.org/lkml/2007/12/6/340

The syslet machinery wants to run some code before and after the system
call itself when the syslet arguments are provided.  It can also call
almost every single system call, white-listing in sys_indirect() is
probably not the answer here.

I could throw together some ideas, of course, but thought I'd see if you
guys already had a design in mind that I could pursue.

- z
