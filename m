Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbYGAWSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbYGAWSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbYGAWSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:18:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800AbYGAWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:18:08 -0400
Date: Tue, 1 Jul 2008 15:16:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <Solofo.Ramangalahy@bull.net>
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com, cmm@us.ibm.com,
       Nadia.Derbey@bull.net, manfred@colorfullife.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH -mm 0/3] sysv ipc: increase msgmnb with the number of
 cpus
Message-Id: <20080701151650.f27a425a.akpm@linux-foundation.org>
In-Reply-To: <20080624093452.946878437@bull.net>
References: <20080624093452.946878437@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 11:34:52 +0200
<Solofo.Ramangalahy@bull.net> wrote:

> The size in bytes of a SysV IPC message queue, msgmnb, is too small
> for large machines, but we don't want to bloat small machines.
> 
> This series change ("scale") the default value of
> /proc/sys/kernel/msgmnb.

I'm afraid I've lost track of what's happening here.  Did we come up
with an alternative to "magical positive-versus-negative number trick"?

Your patch #1 adds and uses recompute_msgmnb() without adding the
declaration to a header file.  Your patch #2 does add the
recompute_msgmnb() to a header file, so we have a window in which the
build is broken, which is bad.

recompute_msgmnb() isn't a terribly good globally-visible identifier,
btw.  It is nice to add some subsystem identifer as a prefix.  There's
little chance of this symbol colliding with anything else, so this is a
minor cosmetic thing in this case.


