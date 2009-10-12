Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZJLUNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZJLUNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbZJLUNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:13:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42392 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbZJLUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:13:50 -0400
Date: Mon, 12 Oct 2009 16:13:04 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v6)
Message-ID: <20091012201304.GG32088@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012161342.GA32088@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.5 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sign, marcin just pointed out that I'm an idiot (thanks :) ).  I posted a
version of this patch that was incorrect.  Heres the right one, with the all the
fixes he requested

Neil

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



