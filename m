Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZCAWVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZCAWVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 17:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZCAWVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 17:21:35 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33316 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZCAWVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 17:21:34 -0500
Date: Sun, 1 Mar 2009 16:21:30 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090301222130.GA27198@us.ibm.com>
References: <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu> <20090226223112.GA2939@x200.localdomain> <20090301013304.GA2428@x200.localdomain> <20090301200231.GA25276@us.ibm.com> <20090301205659.GA7276@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301205659.GA7276@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> On Sun, Mar 01, 2009 at 02:02:31PM -0600, Serge E. Hallyn wrote:
> > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > > On Fri, Feb 27, 2009 at 01:31:12AM +0300, Alexey Dobriyan wrote:
> > > > This is collecting and start of dumping part of cleaned up OpenVZ C/R
> > > > implementation, FYI.
> > > 
> > > OK, here is second version which shows what to do with shared objects
> > > (cr_dump_nsproxy(), cr_dump_task_struct()), introduced more checks
> > > (still no unlinked files) and dumps some more information including
> > > structures connections (cr_pos_*)
> > > 
> > > Dumping pids in under thinking because in OpenVZ pids are saved as
> > > numbers due to CLONE_NEWPID is not allowed in container. In presense
> > > of multiple CLONE_NEWPID levels this must present a big problem. Looks
> > > like there is now way to not dump pids as separate object.
> > > 
> > > As result, struct cr_image_pid is variable-sized, don't know how this will
> > > play later.
> > > 
> > > Also, pid refcount check for external pointers is busted right now,
> > > because /proc inode pins struct pid, so there is almost always refcount
> > > vs ->o_count mismatch.
> > > 
> > > No restore yet. ;-)
> > 
> > Hi Alexey,
> > 
> > thanks for posting this.  Of course there are some predictable responses
> > (I like the simplicity of pure in-kernel, Dave will not :) but this
> > needs to be posted to make us talk about it.
> > 
> > A few more comments that came to me while looking it over:
> > 
> > 1. cap_sys_admin check is unfortunate.  In discussions about Oren's
> > patchset we've agreed that not having that check from the outset forces
> > us to consider security with each new patch and feature, which is a good
> > thing.
> 
> Removing CAP_SYS_ADMIN on restore?

And checkpoint.

-serge
