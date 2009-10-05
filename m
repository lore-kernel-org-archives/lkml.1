Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZJEA1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZJEA1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbZJEA1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:27:06 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52937 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbZJEA1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:27:05 -0400
Date: Sun, 4 Oct 2009 20:26:17 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v4)
Message-ID: <20091005002617.GA5736@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001171538.GB2456@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.5 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, heres attempt number 4, in response to new new set of notes.
 
Change Notes:

1) Cleaned up the memory leaks

2) Added error returns

3) Fixed buffer allocation sizes

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

