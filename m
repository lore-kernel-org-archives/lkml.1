Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZJARPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZJARPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZJARPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:15:40 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36890 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbZJARPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:15:40 -0400
Date: Thu, 1 Oct 2009 13:15:38 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, nhorman@tuxdriver.com
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v3)
Message-ID: <20091001171538.GB2456@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928200600.GA3053@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, heres attempt number 3, in response to your thoughts and concerns Andrew.

Change Notes:
1) Kept ability to set/get rlimits via /proc/pid/limits as in the previous
patches

2) Augmented the patchset with 2 new syscall defines, getprlimit and setprlimit,
which take a pid_t as an additional argument, allowing a user to specify a
process id for the rlimits in question.  The core code for setting rlimits is
shared with the previous patch, and is in do_setrlimit, so that all the security
checks and such remain unaltered.

3) Add syscall numbers to asm-generic/unistd.h so that any arch using the
generic syscall code picks up these new syscalls.  I figure I don't have access
to systems that don't use that code, so I should probably leave those changes up
to the arch maintainers.


Summary

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

