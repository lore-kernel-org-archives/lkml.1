Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZCLOMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZCLOMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZCLOMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:12:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZCLOMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:12:21 -0400
Date: Thu, 12 Mar 2009 10:09:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       arozansk@redhat.com, jmoyer@redhat.com, oz-kernel@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com
Subject: Re: [PATCH 01/10] Documentation
Message-ID: <20090312140936.GF10919@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-2-git-send-email-vgoyal@redhat.com> <1236853490.5090.140.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236853490.5090.140.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 11:24:50AM +0100, Peter Zijlstra wrote:
> On Wed, 2009-03-11 at 21:56 -0400, Vivek Goyal wrote:
> > +Going back to old behavior
> > +==========================
> > +In new scheme of things essentially we are creating hierarchical fair
> > +queuing logic in elevator layer and changing IO schedulers to make use of
> > +that logic so that end IO schedulers start supporting hierarchical scheduling.
> > +
> > +Elevator layer continues to support the old interfaces. So even if fair queuing
> > +is enabled at elevator layer, one can have both new hierarchical scheduler as
> > +well as old non-hierarchical scheduler operating.
> > +
> > +Also noop, deadline and AS have option of enabling hierarchical scheduling.
> > +If it is selected, fair queuing is done in hierarchical manner. If hierarchical
> > +scheduling is disabled, noop, deadline and AS should retain their existing
> > +behavior.
> > +
> > +CFQ is the only exception where one can not disable fair queuing as it is
> > +needed for providing fairness among various threads even in non-hierarchical
> > +mode.
> > +
> > +Various user visible config options
> > +===================================
> > +CONFIG_IOSCHED_NOOP_HIER
> > +       - Enables hierchical fair queuing in noop. Not selecting this option
> > +         leads to old behavior of noop.
> > +
> > +CONFIG_IOSCHED_DEADLINE_HIER
> > +       - Enables hierchical fair queuing in deadline. Not selecting this
> > +         option leads to old behavior of deadline.
> > +
> > +CONFIG_IOSCHED_AS_HIER
> > +       - Enables hierchical fair queuing in AS. Not selecting this option
> > +         leads to old behavior of AS.
> > +
> > +CONFIG_IOSCHED_CFQ_HIER
> > +       - Enables hierarchical fair queuing in CFQ. Not selecting this option
> > +         still does fair queuing among various queus but it is flat and not
> > +         hierarchical.
> 
> One worry I have is that these are compile time switches. Is there any
> way you can get the old AS/DEADLINE back when these are enabled but
> you're not actively using cgroups?

Hi Peter,

In principle, if one is not using cgroups, there is only one io queue
in the root group and most likely we should achieve the same behavior
as old schedulers. Just that some extra code gets into execution at 
runtime.

I have not got a chance yet to do some numbers but I think this path
can be optimized enough that at run time effectively we don't see any 
significant performance penalty and behavior of schedulers is almost
same as old ones.

Thanks
Vivek 
