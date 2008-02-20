Return-Path: <linux-kernel-owner+w=401wt.eu-S1765210AbYBTNCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765210AbYBTNCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYBTNCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:02:34 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:35086 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752936AbYBTNCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:02:33 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Thu, 21 Feb 2008 00:01:44 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 2.6.25-rc2 3/9] config: Improve init/Kconfig help	descriptions - namespaces
Message-ID: <20080220130142.GC2169@tull.net>
References: <20080219140609.GA26619@tull.net> <20080219143307.GA27352@tull.net> <47BAEABF.6050005@openvz.org> <20080219151028.GA28294@tull.net> <47BAF2E5.8050001@openvz.org> <20080219084420.f3104e3f.randy.dunlap@oracle.com> <20080220121915.GA2169@tull.net> <47BC1BA9.5040009@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC1BA9.5040009@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 03:23:05PM +0300, Pavel Emelyanov wrote:
> > +	  This is used by container systems (i.e. vservers).
> > +	  Tasks in the container are placed in the PID namespace
> > +	  corresponding to the container, and can only see or
> > +	  affect processes in the same PID namespace.
> 
> same of one of child namespaces. In other words when you create
> a new pid namespace, you still see the tasks from this new one,
> but the tasks from this one, doesn't see yours :)

Due to the hierarchial nature, I see. I'm still trying to grok
it. Would it be adequate to describe what a process _cannot_
do? i.e.

          This is used by container systems (i.e. vservers).
          Tasks in the container are placed in the PID namespace
          corresponding to the container, and cannot see or
          affect processes in any parent PID namespaces.

Or maybe I should say both what it cannot do and what it can,
so readers don't have to use their imagination much :-)

Let's see if I understand how it works with an example. Say we've
got a hierarchy of PID namespaces ... pidA/pidB/pidC and a new
process created in pidC. This new process may have pid 18925 in
pidA, 2263 in pidB and 56 in pidC?

So if there's another process running in pidC, the first process
may be signaled as pid 56, and if a process is running in pidB
it would be 2263 and not 56. Can a process running in pidB see
all processes running in pidC only with their pidB PIDs?

Now, a process A running in pidA can send a signal to a process
C running in pidC but not vice-versa. Process C cannot know
where the signal came from. Is there any kernel mechanism
which normally would provide that kind of information to
process C but which breaks when PID namespaces are used,
because there's no way to name process A from the context
of pidC ?

Nick.
