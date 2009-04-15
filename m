Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZDOUjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZDOUjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZDOUjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:39:32 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55679 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZDOUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:39:31 -0400
Date: Wed, 15 Apr 2009 15:39:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: CAP_SYS_ADMIN on restart(2) (was: Re: [PATCH 00/30] C/R
	OpenVZ/Virtuozzo style)
Message-ID: <20090415203920.GA5475@us.ibm.com>
References: <20090410023207.GA27788@x200.localdomain> <1239340031.24083.21.camel@nimitz> <20090413091423.GA19236@x200.localdomain> <49E4108A.8050201@cs.columbia.edu> <20090414145830.GA27461@x200.localdomain> <49E4D115.5080601@cs.columbia.edu> <20090414204912.GA28458@x200.localdomain> <20090414213934.GB17986@us.ibm.com> <20090415192150.GC26994@x200.localdomain> <1239827033.32604.167.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239827033.32604.167.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Wed, 2009-04-15 at 23:21 +0400, Alexey Dobriyan wrote:
> > Is sysctl to control CAP_SYS_ADMIN on restart(2) OK?
> 
> If the point is not to let users even *try* restarting things if it
> *might* not work, then I guess this might be reasonable.  
> 
> If the goal is to increase security by always requiring CAP_SYS_ADMIN
> for "dangerous" operations, I fear it will be harmful.  We may have
> people adding features that are not considering the security impact of
> what they're doing just because the cases they care about all require
> privilege.

Nah, I disagree.  (Or put another way, that wouldn't be the goal)
There are two administrators we want to satisfy:

1. the one who wants his users to do partial checkpoints, but doesn't
want to risk giving away any privilege at all in the process.  He'll
be satisified by setting restart(2) to not require cap_sys_admin,
and his users just won't be able to do a whole container.  A lot of
users will be happy with that (though no SYSVIPC support, then).

2. the one who may have one or two users who he trusts to do
checkpoint/restart, but otherwise doesn't want even the slightest
risk of other users using restart, and maybe finding an exploit.
That one is probably the more common admin, and he'll be satisified
with requiring CAP_SYS_ADMIN for all restart(2)'s, since he's ok
risking giving extra privilege to the ones he trusts.

And meanwhile, by virtue of leaving (1) supported, we are still
more under the gun to make sure that everything restart(2) does
is properly checked.

> What would the goal be?
> 
> -- Dave

-serge
