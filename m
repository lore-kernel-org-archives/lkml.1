Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbXCIJiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbXCIJiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993086AbXCIJiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:38:20 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45505 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752663AbXCIJiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:38:19 -0500
Date: Fri, 9 Mar 2007 01:38:17 -0800
From: Paul Jackson <pj@sgi.com>
To: Kirill Korotaev <dev@sw.ru>
Cc: herbert@13thfloor.at, vatsa@in.ibm.com, menage@google.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru
Subject: Re: [PATCH 1/2] rcfs core patch
Message-Id: <20070309013817.5b9b4374.pj@sgi.com>
In-Reply-To: <45F127AB.5070704@sw.ru>
References: <20070301133543.GK15509@in.ibm.com>
	<20070301134528.GL15509@in.ibm.com>
	<m1slcg8m4f.fsf@ebiederm.dsl.xmission.com>
	<20070308101347.GA29051@in.ibm.com>
	<20070309004816.GB4506@MAIL.13thfloor.at>
	<45F127AB.5070704@sw.ru>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill, responding to Herbert:
> > do we need or even want that? IMHO the hierarchical
> > concept CKRM was designed with, was also the reason
> > for it being slow, unuseable and complicated
> 1. cpusets are hierarchical already. So hierarchy is required.

I think that CKRM has a harder time doing a hierarchy than cpusets.

CKRM is trying to account for and control how much of an amorphous
resource is used, whereas cpusets is trying to control whether a
specifically identifiable resource is used, or not used, not how
much of it is used.

A child cpuset gets configured to allow certain CPUs and Nodes, and
then does not need to dynamically pass back any information about
what is actually used - it's a one-way control with no feedback.
That's a relatively easier problem.

CKRM (as I recall it, from long ago ...) has to track the amount
of usage dynamically, across parent and child groups (whatever they
were called.)  That's a harder problem.

So, yes, as Kirill observes, we need the hierarchy because cpusets
has it, cpuset users make good use of the hierarchy, and the hierarchy
works fine in that case, even if a hierarchy is more difficult for CKRM.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
