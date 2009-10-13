Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbZJMAGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbZJMAGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195AbZJMAGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:06:43 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38845 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbZJMAGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:06:42 -0400
Date: Mon, 12 Oct 2009 20:06:01 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, marcin.slusarz@gmail.com
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v5)
Message-ID: <20091013000601.GA2334@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012145810.b2aed62b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012145810.b2aed62b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 02:58:10PM -0700, Andrew Morton wrote:
> On Mon, 12 Oct 2009 12:13:42 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Its been requested often that we have the ability to read and modify process
> > rlimit values from contexts external to the owning process.  Ideally this allows
> > sysadmins to adjust rlimits on long running processes wihout the need to stop
> > and restart those processes, which incurs undesireable downtime.  This patch
> > enables that functionality,  It does so in two places.  First it enables process
> > limit setting by writing to the /proc/pid/limits file a string in the format:
> > <limit> <current limit> <max limit> > /proc/<pid>/limits
> > where limit is one of
> > [as,core,cpu,data,fsize,locks,memlock,msgqueue,nice,nofile,nproc,rss,rtprio,rttime]
> > 
> > Secondly it allows for programatic setting of these limits via 2 new syscalls,
> > getprlimit, and setprlimit, which act in an identical fashion to getrlimit and
> > setrlimit respectively, except that they except a process id as an extra
> > argument, to specify the process id of the rlimit values that you wish to
> > read/write
> 
> I'm still not seeing why we need the /proc interface.
> 
> We've been using a syscall to set rlimits for ever and we've survived.
> 
Except that we haven't.  We've had the read side of the proc interface for years
now, simply because people asked for it.  We could have add getprlimit back
then, but we didn't because users liked this.  Its easy, its obvious, and and it
doesn't require a sysadmin to remember the name of another utility.

> It just adds bloat and complexity to the kernel because putting a
> 100-line tool into util-linux is All Too Hard.
> 
And, with the adjustments to support the getprlimit/setprlimit syscalls in this
series, the net additional code to support a writeable /proc interface totals
about 80 lines.  I really think 'bloat' is a bit of an overstatement here.  If
you're really that worried about it, we can surround the proc interface with a
config option.  But at this point people have become acoustomed to having
/proc/pid/limits available, I don't see why 80 lines to add the ability to set
limits is really that much of a barrier.

Neil

