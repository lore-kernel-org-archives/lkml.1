Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXCLR0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXCLR0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXCLR0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:26:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35309 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXCLR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:26:05 -0400
Date: Mon, 12 Mar 2007 12:25:57 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       sam@vilain.net, dev@sw.ru, xemul@sw.ru, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070312172557.GD12893@sergelap.austin.ibm.com>
References: <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070309163430.GN6504@in.ibm.com> <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com> <20070312150756.GB24742@in.ibm.com> <20070312155643.GA12893@sergelap.austin.ibm.com> <20070312162045.GD12176@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312162045.GD12176@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> On Mon, Mar 12, 2007 at 10:56:43AM -0500, Serge E. Hallyn wrote:
> > What's wrong with that?
> 
> I had been asking around on "what is the fundamental unit of res mgmt
> for vservers" and the answer I got (from Herbert) was "all tasks that are
> in the same pid namespace". From what you are saying above, it seems to
> be that there is no such "fundamental" unit. It can be a random mixture
> of tasks (taken across vservers) whose resource consumption needs to be
> controlled. Is that correct?

If I'm reading it right, yes.

If for vservers the fundamental unit of res mgmt is a vserver, that can
surely be done at a higher level than in the kernel.

Actually, these could be tied just by doing

	mount -t container -o ns,cpuset /containers

So now any task in /containers/vserver1 or any subdirectory thereof
would have the same cpuset constraints as /containers.  OTOH, you could
mount them separately

	mount -t container -o ns /nsproxy
	mount -t container -o cpuset /cpuset

and now you have the freedom to split tasks in the same vserver
(under /nsproxy/vserver1) into different cpusets.

-serge

> > > 	echo "cid 2" > /dev/cpu/prof/tasks 
> > 
> > Adding that feature sounds fine, 
> 
> Ok yes ..that can be a optional feature.
> 
> -- 
> Regards,
> vatsa
