Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYEGBcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYEGBcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYEGBcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:32:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbYEGBcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:32:08 -0400
Date: Tue, 6 May 2008 18:31:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506183138.546f42d9.akpm@linux-foundation.org>
In-Reply-To: <48210101.1070205@google.com>
References: <48210101.1070205@google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 18:08:17 -0700 Paul Menage <menage@google.com> wrote:

> Fix cpuset sched_relax_domain_level control file
> 
> Due to a merge conflict, the sched_relax_domain_level control file was
> marked as being handled by cpuset_read/write_u64, but the code to handle it
> was actually in cpuset_common_file_read/write.
> 
> Since the value being written/read is in fact a signed integer, it
> should be treated as such; this patch adds cpuset_read/write_s64
> functions, and uses them to handle the sched_relax_domain_level file.
> 
> With this patch, the sched_relax_domain_level can be read and written,
> and the correct contents seen/updated.
> 

OK, here we go again.

There is a patch in linux-next called "cpuset: system sets" which will
conflict with your change.

A bit of archeology indicates that this patch was sent out on Feb 27 and
received a bit of review feedback, including some serious-looking qualms
from Paul.  There was no response to that reviewer feedback and volia, the
damn code goes into linux-next without, afaict, any alteration.

Ingo, for the entyenth time: kernel/cpuset.c is not part of the CPU
scheduler.

argh.  Now what to do?  If I merge this patch then I need to drop
linux-next and if I drop linux-next I drop half my tree.

So I guess I need to merge this patch and then somehow smash linux-next on
top of it.  Thanks a lot.

