Return-Path: <linux-kernel-owner+w=401wt.eu-S2992533AbXDDDAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992533AbXDDDAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992553AbXDDDAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:00:33 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48843 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992533AbXDDDAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:00:32 -0400
Date: Wed, 4 Apr 2007 08:37:56 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070404030756.GA9008@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070403153220.GA24946@sergelap.austin.ibm.com> <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com> <20070403164615.GJ2456@in.ibm.com> <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com> <20070403171155.GK2456@in.ibm.com> <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com> <20070403173048.GL2456@in.ibm.com> <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com> <20070403175101.GN2456@in.ibm.com> <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:49:49AM -0700, Paul Menage wrote:
> > Why is the hierarchy bit important here? Usually controllers need to
> > know "tell me what cpuset this task belongs to", which is answered
> > by tsk->nsproxy->ctlr_data[CPUSET_ID].
> 
> I was thinking of queries from userspace.

User space queries like "what is the cpuset to which this task belongs",
where the answer needs to be something of the form "/dev/cpuset/C1"?
The patches address that requirement atm by having a dentry pointer in 
struct cpuset itself.

Do you see similar queries coming in for every resource controller object
(show me the path of cpu_acct, cpu_ctl, rss_ctl ... objects to which this
task belongs)? IMO that will not be the case, in which case we can avoid
adding N pointers (N = max hierarchies) in nsproxy just to support queries of 
those sort.

If additional resource objects need to support such queries in future, we could 
add a dentry pointer in those objects as and when the need arises.

-- 
Regards,
vatsa
