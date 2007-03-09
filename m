Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbXCIRuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbXCIRuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbXCIRuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:50:18 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49004 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbXCIRuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:50:16 -0500
Date: Fri, 9 Mar 2007 23:27:07 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Menage <menage@google.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, pj@sgi.com, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] rcfs core patch
Message-ID: <20070309175707.GA21661@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301134528.GL15509@in.ibm.com> <m1slcg8m4f.fsf@ebiederm.dsl.xmission.com> <6599ad830703080110j15aa961anc39954928cbc3851@mail.gmail.com> <20070309003819.GA4506@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309003819.GA4506@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 01:38:19AM +0100, Herbert Poetzl wrote:
> > 2) you allow a task to selectively reshare namespaces/subsystems with
> >    another task, i.e. you can update current->task_proxy to point to
> >    a proxy that matches your existing task_proxy in some ways and the
> >    task_proxy of your destination in others. In that case a trivial
> >    implementation would be to allocate a new task_proxy and copy some
> >    pointers from the old task_proxy and some from the new. But then
> >    whenever a task moves between different groupings it acquires a
> >    new unique task_proxy. So moving a bunch of tasks between two
> >    groupings, they'd all end up with unique task_proxy objects with
> >    identical contents.
> 
> this is exactly what Linux-VServer does right now, and I'm
> still not convinced that the nsproxy really buys us anything
> compared to a number of different pointers to various spaces
> (located in the task struct)

Are you saying that the current scheme of storing pointers to different
spaces (uts_ns, ipc_ns etc) in nsproxy doesn't buy anything? 

Or are you referring to storage of pointers to resource (name)spaces 
in nsproxy doesn't buy anything?

In either case, doesn't it buy speed and storage space?

> I'd prefer to do accounting (and limits) in a very simple
> and especially performant way, and the reason for doing
> so is quite simple:

Can you elaborate on the relationship between data structures used to store 
those limits to the task_struct? Does task_struct store pointers to those 
objects directly?

-- 
Regards,
vatsa
