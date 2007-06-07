Return-Path: <linux-kernel-owner+w=401wt.eu-S966012AbXFGAqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012AbXFGAqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbXFGAqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:46:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56118 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755211AbXFGAqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:46:13 -0400
Date: Wed, 6 Jun 2007 17:46:09 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       rohitseth@google.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, cpw@sgi.com, serue@us.ibm.com, menage@google.com,
       svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process
 Containers
Message-Id: <20070606174609.bfa01446.pj@sgi.com>
In-Reply-To: <20070607000559.GA19529@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070604191412.GA901@sergelap.austin.ibm.com>
	<20070604123151.4db007a6.pj@sgi.com>
	<6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
	<20070604204131.GB19409@sergelap.austin.ibm.com>
	<20070604140533.65e25286.pj@sgi.com>
	<20070606223952.GB5626@sergelap.austin.ibm.com>
	<20070606154347.a155630b.pj@sgi.com>
	<20070607000559.GA19529@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I suppose as a cleaner alternative we could 
> add a container_subsys->inherit_defaults() handler, to be called at
> container_clone(), and for cpusets this would set cpus and mems to
> the parent values - sibling exclusive values.  If that comes to nothing,
> then the attach_task() is still refused, and the unshare() or clone()
> fails, but this time with good reason.

Unfortunately, I haven't spent the time I should thinking about
container cloning, namespaces and such.

I don't know, for the workloads that matter to me, when, how or
if this container cloning will be used.

I'm tempted to suggest the following.

First, I am assuming that the classic method of creating cpuset
children will still work, such as the following (which can fail
for certain combinations of exclusive cpus or mems):
	cd /dev/cpuset/foobar
	mkdir foochild
	cp cpus foochild
	cp mems foochild
	echo $$ > foochild/tasks

Second, given that, how about you fail the unshare() or clone()
anytime that the instance to be cloned has any sibling cpusets
with any exclusive flags set.

The exclusive property is not really on friendly terms with cloning.

Now if the above classic code must be encoded using cloning under
the covers, then we've got problems, probably more problems than
just this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
