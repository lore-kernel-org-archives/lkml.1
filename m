Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZBLW54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZBLW54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbZBLW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:57:44 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44008 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbZBLW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:57:43 -0500
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       orenl@cs.columbia.edu, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Thomas Gleixner <tglx@linutronix.de>, Cedric Le Goater <clg@fr.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <1234467035.3243.538.camel@calx>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1234285547.30155.6.camel@nimitz>
	 <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz>  <1234467035.3243.538.camel@calx>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 14:57:37 -0800
Message-Id: <1234479457.30155.214.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 13:30 -0600, Matt Mackall wrote:
> On Thu, 2009-02-12 at 10:11 -0800, Dave Hansen wrote:
...
> >  * Filesystem state
> >   * contents of files
> >   * mount tree for individual processes
> >  * flock
> >  * threads and sessions
> >  * CPU and NUMA affinity
> >  * sys_remap_file_pages()
> 
> I think the real questions is: where are the dragons hiding? Some of
> these are known to be hard. And some of them are critical checkpointing
> typical applications. If you have plans or theories for implementing all
> of the above, then great. But this list doesn't really give any sense of
> whether we should be scared of what lurks behind those doors.

This is probably a better question for people like Pavel, Alexey and
Cedric to answer.  

> Some of these things we probably don't have to care too much about. For
> instance, contents of files - these can legitimately change for a
> running process. Open TCP/IP sockets can legitimately get reset as well.
> But others are a bigger deal.

Legitimately, yes.  But, practically, these are things that we need to
handle because we want to make any checkpoint/restart as transparent as
possible.  Resetting people's network connections is not exactly illegal
but not very nice or transparent either.

> Also, what happens if I checkpoint a process in 2.6.30 and restore it in
> 2.6.31 which has an expanded idea of what should be restored? Do your
> file formats handle this sort of forward compatibility or am I
> restricted to one kernel?

In general, you're restricted to one kernel.  But, people have mentioned
that, if the formats change, we should be able to write in-userspace
converters for the checkpoint files.  

-- Dave

