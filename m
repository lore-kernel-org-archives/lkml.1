Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbZJLQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbZJLQO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932757AbZJLQO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:14:27 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60970 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbZJLQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:14:26 -0400
Date: Mon, 12 Oct 2009 12:13:42 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v5)
Message-ID: <20091012161342.GA32088@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001171538.GB2456@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, Sorry for the delay, I had several other items that I needed to finish.
Version 5 of this patch set taking Marcins notes into account

Change Notes:

1) Fixed up various buffer leaks, sizings, and other misc. items that Marcin
pointed out in his last post to this thread

2) Added documentation in Documentation/filesystems/proc.txt so that users
would have a better idea about how to use the proc interface here (I figured
that the syscall interface would be rather self explanitory and get augmented
into the man pages soon enough)

Neil


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


