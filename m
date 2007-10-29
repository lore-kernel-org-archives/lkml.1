Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXJ2RWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXJ2RWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbXJ2RWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:22:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:51437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbXJ2RWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:22:40 -0400
Date: Mon, 29 Oct 2007 10:20:58 -0700
From: Tony Jones <tonyj@suse.de>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] audit: clear thread flag for new children
Message-ID: <20071029172058.GA8433@suse.de>
References: <20071026204228.GA1519@suse.de> <200710271021.42093.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710271021.42093.sgrubb@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 10:21:39AM -0400, Steve Grubb wrote:
> On Friday 26 October 2007 04:42:28 pm Tony Jones wrote:
> > Thread flag TIF_SYSCALL_AUDIT is not cleared for new children when audit
> > context creation has been disabled (auditctl -e0). This can cause new
> > children forked from a parent created when audit was enabled to not take
> > the fastest syscall path thru entry.S
> 
> This came up almost 2 years ago:
> 
> https://www.redhat.com/archives/linux-audit/2005-September/msg00048.html

I was not aware of this, thanks.

> The problem is that removing that flag makes the children unauditable in the 
> future. The only place that flag gets set is during fork. 

I don't see this.  The case that would be undesirable would be for a task
to have an audit context but to not have the thread flag enabled.  That isn't
the case.  This was the point Chris made in his Ack, although perhaps somewhat
tersely.

> Unless I'm missing something, to make all children auditable again would 
> mean stopping all processes and or'ing that flag into all thread info areas. 

I think you are.  Or maybe the code was different two years ago so that the
above made sense.   

In the above scenario, audit is disabled, a new child is forked, we bail
early so there is no audit context (and now there is no flag in the thread
area).   Currently there is no way this task is ever going to be audited as 
there is no audit context.    If this task forks a new child, at this point
the value of audit enabled will determine if there should be a context 
allocated and it will allocate the TIF flag also.   I don't see your stopping
all processes scenario.

> I do not want to propose that patch to LKML.  :)

;-)

Tony
