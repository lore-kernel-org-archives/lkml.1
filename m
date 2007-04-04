Return-Path: <linux-kernel-owner+w=401wt.eu-S2992588AbXDDFIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992588AbXDDFIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992602AbXDDFIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:08:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43088 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992588AbXDDFIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:08:02 -0400
Date: Wed, 4 Apr 2007 10:45:26 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070404051526.GA16562@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070403164615.GJ2456@in.ibm.com> <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com> <20070403171155.GK2456@in.ibm.com> <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com> <20070403173048.GL2456@in.ibm.com> <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com> <20070403175101.GN2456@in.ibm.com> <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com> <20070404030756.GA9008@in.ibm.com> <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 09:04:59PM -0700, Paul Menage wrote:
> Have you posted the cpuset implementation over your system yet?

Yep, here:

http://lists.linux-foundation.org/pipermail/containers/2007-March/001497.html

For some reason, the above mail didnt make it into lkml (maybe it
exceeded the max size allowed). I also have a updated version of that
which I hope to post as soon as I am done with something else I am
working on (sigh ..)

> The drawback to that is that every subsystem has to add a dentry to
> its state, and handle the processing.

Again this depends on whether every subsystem need to be able to support
the user-space query you pointed out.

> >Do you see similar queries coming in for every resource controller object
> >(show me the path of cpu_acct, cpu_ctl, rss_ctl ... objects to which this
> >task belongs)? IMO that will not be the case, in which case we can avoid
> >adding N pointers (N = max hierarchies) in nsproxy just to support queries 
> >of
> >those sort.
> 
> OK, I see your argument that putting it in the aggregator probably
> isn't the best thing to do from a space point of view in the case when
> the number of aggregators

Sorry that sentence seems to be garbled by some mail router :)

Did you mean to say "when the number of aggregators sharing the same
container object are more" ?

I agree ..Putting N pointers in container_group object just to support
queries isn't justified at this point, because we don't know whether all
subsystems need to support such queries.

> This seems like a place where my container_subsys_state object is
> useful - it can store a pointer to the container object (and be
> maintained by the generic container system), at a space cost of 1
> pointer per subsystem grouping, rather than N pointers per aggregator.

Yes that would be better than having N pointers in aggregator. From
supporting purely user-space query pov, I think that is roughly same
as having a 'dentry pointer' per resource object (what I mentioned earlier). 

IMO we should add a dentry/container_subsys_state pointer only for those 
subsystems which need to support such queries ..


-- 
Regards,
vatsa
