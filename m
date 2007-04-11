Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXDKSuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXDKSuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXDKSuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:50:22 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56427 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbXDKSuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:50:20 -0400
Date: Wed, 11 Apr 2007 11:49:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@sw.ru>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] Cpu statistics accounting based on Paul Menage patches
Message-Id: <20070411114927.1277d7c9.akpm@linux-foundation.org>
In-Reply-To: <461CF883.2030308@sw.ru>
References: <461CF883.2030308@sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 19:02:27 +0400
Pavel Emelianov <xemul@sw.ru> wrote:

> Provides a per-container statistics concerning the numbers of tasks
> in various states, system and user times, etc. Patch is inspired
> by Paul's example of the used CPU time accounting. Although this
> patch is independent from Paul's example to make it possible playing
> with them separately.

Why is this actually needed?  If userspace has a list of the tasks which
are in a particular container, it can run around and add up the stats for
those tasks without kernel changes?

It's a bit irksome that we have so much accounting of this form in core
kernel, yet we have to go and add a completely new implementation to create
something which is similar to what we already have.  But I don't
immediately see a fix for that.  Apart from paragraph #1 ;)

Should there be linkage between per-container stats and
delivery-via-taskstats?  I can't think of one, really.

You have cpu stats.  Later, presumably, we'll need IO stats, MM stats,
context-switch stats, number-of-syscall stats, etc, etc.  Are we going to
reimplement all of those things as well?  See paragraph #1!

Bottom line: I think we seriously need to find some way of consolidating
per-container stats with our present per-task stats.  Perhaps we should
instead be looking at ways in which we can speed up paragraph #1.
