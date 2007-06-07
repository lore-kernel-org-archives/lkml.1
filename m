Return-Path: <linux-kernel-owner+w=401wt.eu-S935703AbXFGTVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935703AbXFGTVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934013AbXFGTV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:21:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57760 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933835AbXFGTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:21:27 -0400
Date: Thu, 7 Jun 2007 12:21:21 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: serue@us.ibm.com, vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net,
       balbir@in.ibm.com, rohitseth@google.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, containers@lists.osdl.org, devel@openvz.org,
       ebiederm@xmission.com, mbligh@google.com, cpw@sgi.com,
       menage@google.com, svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process
 Containers
Message-Id: <20070607122121.24fe6ff4.pj@sgi.com>
In-Reply-To: <20070607180158.GA936@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070604191412.GA901@sergelap.austin.ibm.com>
	<20070604123151.4db007a6.pj@sgi.com>
	<6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
	<20070604204131.GB19409@sergelap.austin.ibm.com>
	<20070604140533.65e25286.pj@sgi.com>
	<20070606223952.GB5626@sergelap.austin.ibm.com>
	<20070606154347.a155630b.pj@sgi.com>
	<20070607000559.GA19529@sergelap.austin.ibm.com>
	<20070606174609.bfa01446.pj@sgi.com>
	<20070607180158.GA936@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> For /cpusets/set0/set1 to have cpu 1 exclusively, does /cpusets/set0
> also have to have it exclusively?

Yes.

> If so, then clearly this approach won't work, since if any container has
> exclusive cpus, then every container will have siblings with exclusive
> cpus, and unshare still isn't possible on the system.

Well, if I'm following you, not exactly.

If we have some exclusive flags set, then every top level container
will have exclusive siblings, but further down the hierarchy, some
subtree might be entirely free of any exclusive settings.  Then nodes
below the top of that subtree would not have exclusive set, and would
not have any exclusive siblings.

But, overall, yeah, exclusive is no friend of container cloning.

I just wish I had been thinking harder about how container cloning
will impact my life, and the lives of the customers in my cpuset
intensive corner of the world.

There are certainly a whole bunch of people who will never have any
need for exclusive cpusets.

Perhaps (speculating wildly from great ignorance) there are a whole
bunch of people who will never have need for container cloning.

And perhaps, hoping to get lucky here, the set of people who need both
at the same time on the same system is sufficiently close to empty
that we can just tell them tough toenails - you cannot do both at once.

How wide spread will be the use of container cloning, if it proceeds
as envisioned?

The set of people using exclusive cpusets is roughly some subset of
those running multiple, cpuset isolated, non-cooperating jobs on big
iron, usually with the aid of a batch scheduler.  Well, that's what
I am aware of anyway.  If there are any other friends of exclusive
cpusets lurking here, you might want to speak up, before I sell your
interests down the river.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
