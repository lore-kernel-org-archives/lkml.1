Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZJTAwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZJTAwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZJTAwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:52:23 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41044 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbZJTAwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:52:22 -0400
Date: Mon, 19 Oct 2009 20:52:15 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com, nhorman@tuxdriver.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091020005214.GA8886@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012201304.GG32088@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I give.  I was hoping that some of the requestors of this feature would pipe
up and support the use case for the proc file interface to set limits.  clearly
they're not that interested, but I still think theres merit in the patch.  So
heres version 7 of this patch set.  Its the same as before, but the proc
interface has been dropped, leaving only the syscall interface behind.  I've
tested the interface on intel 32 and 64 bit, with success

Summary:

Its been requested often that we have the ability to read and modify process
rlimit values from contexts external to the owning process.  Ideally this allows
sysadmins to adjust rlimits on long running processes wihout the need to stop
and restart those processes, which incurs undesireable downtime.  This patch
enables that functionality,  It does so in two places.  First it enables process
limit setting by writing to the /proc/pid/limits file a string in the format:
<limit> <current limit> <max limit> > /proc/<pid>/limits
where limit is one of
[as,core,cpu,data,fsize,locks,memlock,msgqueue,nice,nofile,nproc,rss,rtprio,rttime]

Secondly it allows for programatic setting of these limits via 2 new syscalls,
getprlimit, and setprlimit, which act in an identical fashion to getrlimit and
setrlimit respectively, except that they except a process id as an extra
argument, to specify the process id of the rlimit values that you wish to
read/write

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
 
 
 
 
