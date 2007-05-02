Return-Path: <linux-kernel-owner+w=401wt.eu-S1161255AbXEBDic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161255AbXEBDic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161399AbXEBDic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:38:32 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48518 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161255AbXEBDib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:38:31 -0400
Date: Wed, 2 May 2007 09:16:28 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, rohitseth@google.com, pj@sgi.com,
       ebiederm@xmission.com, mbligh@google.com, containers@lists.osdl.org,
       serue@us.ibm.com, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 3/9] Containers (V9): Add tasks file interface
Message-ID: <20070502034628.GB7311@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070427104607.252541000@menage.corp.google.com> <20070427111300.406327000@menage.corp.google.com> <46378311.6000703@linux.vnet.ibm.com> <6599ad830705011337r6f200baen841919ac17c6f38b@mail.gmail.com> <20070502032541.GA7311@in.ibm.com> <6599ad830705012025r64eed906sebe4b38d9977c036@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830705012025r64eed906sebe4b38d9977c036@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 08:25:35PM -0700, Paul Menage wrote:
> >        - Walk the task table and find relevant members
> 
> That doesn't seem like a terrible solution to me, unless you expect
> the class limit to be changing incredibly frequently.

yeah i agree. Group limit(s) should not be changing so frequently.

> >          perhaps
> >        - Move p->load_weight to a class structure
> 
> Sounds like a good idea if you can do it - but if it's per-process,
> how would it fit in the class structure?

p->load_weight essentially depends on two things:

	- nice value or static priority (which is per process, already present 
	  in task_struct)
	- class limit (which is per class)

So in theory we can eliminate the load_weight field in task_struct and
compute it at runtime from the above two fields, although it will be
slightly inefficient I guess to compute the value every time a task is
added to the runqueue. If that is not desirable, then we can stick with
option 1 (walk task list and change member task's->load_weight upon class
limit change).

-- 
Regards,
vatsa
