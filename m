Return-Path: <linux-kernel-owner+w=401wt.eu-S1750964AbXCGQYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964AbXCGQYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXCGQYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:24:16 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34130 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXCGQYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:24:15 -0500
Date: Wed, 7 Mar 2007 22:01:12 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, pj@sgi.com, ebiederm@xmission.com,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       serue@us.ibm.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 2/7] containers (V7): Cpusets hooked into containers
Message-ID: <20070307163112.GA6504@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.290909000@menage.corp.google.com> <20070307143412.GC32105@in.ibm.com> <6599ad830703070801r3f4cd5bak8cbc9b3090ec4490@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703070801r3f4cd5bak8cbc9b3090ec4490@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:01:32AM -0800, Paul Menage wrote:
> > > @@ -913,12 +537,14 @@ static int update_nodemask(struct cpuset
> > >       int migrate;
> > >       int fudge;
> > >       int retval;
> > > +     struct container *cont;
> >
> > This seems to be redundant?
> 
> It gets used in the lower loop checking for processes whose memory
> policies we should be rebinding.

It makes sense in the first cpuset patch
(cpusets_using_containers.patch), but should be removed in the second
cpuset patch (multiuser_container.patch). In the 2nd patch, we use this
comparison:

	if (task_cs(p) != cs)
		continue;

cont variable introduced in the 1st patch essentially becomes unused
after 2nd patch.

-- 
Regards,
vatsa
