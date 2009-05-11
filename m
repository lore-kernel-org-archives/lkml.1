Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZEKB35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZEKB35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbZEKB3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:29:47 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43489 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379AbZEKB3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:29:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18951.32643.749495.538351@drongo.ozlabs.ibm.com>
Date: Mon, 11 May 2009 11:29:39 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
In-Reply-To: <20090508170028.837558214@chello.nl>
References: <20090508165219.469818319@chello.nl>
	<20090508170028.837558214@chello.nl>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Corey noticed that ioctl()s on grouped counters didn't work on the whole group.
> This extends the ioctl() interface to take a second argument that is
> interpreted as a flags field. We then provide PERF_IOC_FLAG_GROUP to toggle
> the behaviour.
> 
> Having this flag gives the greatest flexibility, allowing you to individually
> enable/disable/reset counters in a group, or all together.

As far as enable/disable are concerned, I don't think this is really
necessary.  My intention was that if you want to enable/disable a
whole group you just enable/disable the leader and leave all its
siblings enabled, since if the leader is disabled the whole group
can't go on.

Corey's problem was that we have a bug where enabling the leader only
puts the leader on and not the enabled group members.  I meant to send
a patch to fix that ages ago but I got distracted.  I'll send out the
patch shortly.

Paul.
