Return-Path: <linux-kernel-owner+w=401wt.eu-S933391AbZJLV7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbZJLV7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933381AbZJLV7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:59:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933379AbZJLV7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:59:46 -0400
Date: Mon, 12 Oct 2009 14:58:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, marcin.slusarz@gmail.com
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
 external to a process (v5)
Message-Id: <20091012145810.b2aed62b.akpm@linux-foundation.org>
In-Reply-To: <20091012161342.GA32088@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org>
	<20091001171538.GB2456@hmsreliant.think-freely.org>
	<20091012161342.GA32088@hmsreliant.think-freely.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 12:13:42 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> Its been requested often that we have the ability to read and modify process
> rlimit values from contexts external to the owning process.  Ideally this allows
> sysadmins to adjust rlimits on long running processes wihout the need to stop
> and restart those processes, which incurs undesireable downtime.  This patch
> enables that functionality,  It does so in two places.  First it enables process
> limit setting by writing to the /proc/pid/limits file a string in the format:
> <limit> <current limit> <max limit> > /proc/<pid>/limits
> where limit is one of
> [as,core,cpu,data,fsize,locks,memlock,msgqueue,nice,nofile,nproc,rss,rtprio,rttime]
> 
> Secondly it allows for programatic setting of these limits via 2 new syscalls,
> getprlimit, and setprlimit, which act in an identical fashion to getrlimit and
> setrlimit respectively, except that they except a process id as an extra
> argument, to specify the process id of the rlimit values that you wish to
> read/write

I'm still not seeing why we need the /proc interface.

We've been using a syscall to set rlimits for ever and we've survived.

It just adds bloat and complexity to the kernel because putting a
100-line tool into util-linux is All Too Hard.

