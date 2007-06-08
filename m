Return-Path: <linux-kernel-owner+w=401wt.eu-S970639AbXFHSIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970639AbXFHSIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968440AbXFHSIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:08:43 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58765 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968664AbXFHSIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:08:42 -0400
Date: Fri, 8 Jun 2007 13:08:37 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Paul Jackson <pj@sgi.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       rohitseth@google.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, cpw@sgi.com, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070608180837.GA5683@sergelap.austin.ibm.com>
References: <20070607000559.GA19529@sergelap.austin.ibm.com> <20070606174609.bfa01446.pj@sgi.com> <20070607180158.GA936@sergelap.austin.ibm.com> <20070607122121.24fe6ff4.pj@sgi.com> <20070607201723.GA17011@sergelap.austin.ibm.com> <20070607150113.f020d8f8.pj@sgi.com> <20070608143250.GA7728@vino.hallyn.com> <6599ad830706080855n22612814u4805d34a295b165f@mail.gmail.com> <20070608160840.GA11133@vino.hallyn.com> <6599ad830706080916j477e08c0l8b142d9a0d832c76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830706080916j477e08c0l8b142d9a0d832c76@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 6/8/07, Serge E. Hallyn <serge@hallyn.com> wrote:
> >
> >The problem is container_clone() doesn't call ->create explicitly, it
> >does vfs_mkdir.  So we have no real way of passing in clone_task.
> >
> 
> Good point.
> 
> Looking at vfs_mkdir(), it's pretty simple, and really the only bits
> that apply to container_clone() are the call to ->mkdir() and possibly
> the call to fsnotify_mkdir(). (I think that's maybe how you did it
> originally?)

Yes it was.

> Maybe it would make sense to just call container_create() at that
> point directly, which would allow us more parameters.

I do fear that that could become a maintenance nightmare.  For instance
right now there's the call to fsnotify_mkdir().  Other such hooks might
be placed at vfs_mkdir, which we'd then likely want to have placed in
our container_mkdir() and container_clone() fns.  And of course
may_create() is static inline in fs/namei.c.  It's trivial, but still if
it changes we'd want to change the version in kernel/container.c as
well.

What would be the main advantage of doing it this way?  Do you consider
the extra subys->auto_setup() hook to be avoidable bloat?

thanks,
-serge
