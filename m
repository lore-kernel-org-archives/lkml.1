Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXEBDSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXEBDSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXEBDSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:18:11 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56511 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768AbXEBDRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:17:51 -0400
Date: Wed, 2 May 2007 08:55:41 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, rohitseth@google.com, pj@sgi.com,
       ebiederm@xmission.com, mbligh@google.com, containers@lists.osdl.org,
       serue@us.ibm.com, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 3/9] Containers (V9): Add tasks file interface
Message-ID: <20070502032541.GA7311@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070427104607.252541000@menage.corp.google.com> <20070427111300.406327000@menage.corp.google.com> <46378311.6000703@linux.vnet.ibm.com> <6599ad830705011337r6f200baen841919ac17c6f38b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830705011337r6f200baen841919ac17c6f38b@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 01:37:24PM -0700, Paul Menage wrote:
> > Any chance we could get a per-container task list? It will
> > help subsystem writers as well.
> 
> It would be possible, yes - but we probably wouldn't want the overhead
> (additional ref counts and list manipulations on every fork/exit) of
> it on by default. We could make it a config option that particular
> subsystems could select.
> 
> I guess the question is how useful is this really, compared to just
> doing a do_each_thread() and seeing which tasks are in the container?
> Certainly that's a non-trivial operation, but in what circumstances is
> it really necessary to do it?

For the CPU controller I was working on, (a fast access to) such a list would 
have been valuable. Basically each task has a weight associated with it
(p->load_weight) which is made to depend upon its class limit. Whenever
the class limit changes, we need to go and change all its member task's 
->load_weight value. 

If you don't maintain the per-container task list, I guess I could still
work around it, by either:

	- Walk the task table and find relevant members, OR better
	  perhaps
	- Move p->load_weight to a class structure

-- 
Regards,
vatsa
