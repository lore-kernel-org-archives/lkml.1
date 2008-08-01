Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYHAMFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYHAMFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYHAME5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:04:57 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39286 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626AbYHAME4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:04:56 -0400
Date: Fri, 1 Aug 2008 07:04:55 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on
	num_possible_cpus().
Message-ID: <20080801120455.GP9663@sgi.com>
References: <20080731170022.GE9663@sgi.com> <m1prot297c.fsf@frodo.ebiederm.org> <20080731193204.GG9663@sgi.com> <m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com> <m1bq0d1zhz.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bq0d1zhz.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 03:04:56PM -0700, Eric W. Biederman wrote:
> Robin Holt <holt@sgi.com> writes:
> 
> > Like so???
> >
> > I have not tested this yet.
> 
> Looks reasonable to me.
> 
> In what circumstances was the lookup in the pid hash table with
> long changes causing a performance slowdown?.  We don't perform
> a lot of lookups.

It was initially detected while profiling 'ps' on a 2048p machine that
had 13 kernel threads per cpu.  We added a couple more device drivers
which added additional threads.  We then started a pthread-on-process
MPI job which had 2048 ranks each with 4 threads (test-case from
customer job).  There were misc other processes out there which brought
our task count up to approx 63k.  Larger page size helped the problem
(went from 16k to 64k).

Thanks,
Robin
