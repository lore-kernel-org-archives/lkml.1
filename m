Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYGOQHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYGOQHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGOQHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:07:31 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50071 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752155AbYGOQHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:07:30 -0400
Date: Tue, 15 Jul 2008 11:07:26 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, maxk@qualcomm.com,
       a.p.zijlstra@chello.nl, menage@google.com
Subject: Re: [PATCH] cpuset: Make rebuild_sched_domains() usable from any
 context
Message-Id: <20080715110726.5837c783.pj@sgi.com>
In-Reply-To: <1216122293-4888-1-git-send-email-maxk@qualcomm.com>
References: <1216122293-4888-1-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> Basically as Paul J. pointed out rebuild_sched_domains() is the
> only way to rebuild sched domains correctly based on the current
> cpuset settings. What this means is that we need to be able to
> call it from different contexts, like cpuhotplug for example.

The following is just a wild idea.

On systems using cpusets to setup scheduler domains (anything more
elaborate than the default of a single, system-wide, domain) have a
special purpose thread sit around, that does nothing except rebuild
sched domains on demand.

If this rebuild thread was the -only- way that sched domains were
allowed to be rebuilt, and if this rebuild was done -asynchronously-
sometime shortly after requested, without any error or status feedback,
then it would seem to simplify the locking issues.

I would guess that any system big enough to have a non-default, cpuset
determined, sched domain configuration is big enough to not mind one
more thread sitting around, doing nothing most of the time.

If the above is a really stupid idea, have fun taking out your
agression on it ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
