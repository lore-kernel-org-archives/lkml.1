Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbXEKGHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbXEKGHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXEKGHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:07:46 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53640 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXEKGHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:07:44 -0400
Date: Fri, 11 May 2007 11:39:06 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>, jeffschroeder@computer.org,
       Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH 2/2] file capabilities: accomodate >32 bit capabilities
Message-ID: <20070511060906.GA7050@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070508191548.GA29913@sergelap.austin.ibm.com> <20070508191704.GC29913@sergelap.austin.ibm.com> <20070508205826.GH6375@schatzie.adilger.int> <20070508214914.GA27582@sergelap.austin.ibm.com> <20070510200127.GH6375@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510200127.GH6375@schatzie.adilger.int>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 01:01:27PM -0700, Andreas Dilger wrote:
> On May 08, 2007  16:49 -0500, Serge E. Hallyn wrote:
> > Quoting Andreas Dilger (adilger@clusterfs.com):
> > > One of the important use cases I can see today is the ability to
> > > split the heavily-overloaded e.g. CAP_SYS_ADMIN into much more fine
> > > grained attributes.
> > 
> > Sounds plausible, though it suffers from both making capabilities far
> > more cumbersome (i.e. finding the right capability for what you wanted
> > to do) and backward compatibility.  Perhaps at that point we should
> > introduce security.capabilityv2 xattrs.  A binary can then carry
> > security.capability=CAP_SYS_ADMIN=p, and
> > security.capabilityv2=cap_may_clone_mntns=p.
> 
> Well, the overhead of each EA is non-trivial (16 bytes/EA) for storing
> 12 bytes worth of data, so it is probably just better to keep extending
> the original capability fields as was in the proposal.
> 
> > > What we definitely do NOT want to happen is an application that needs
> > > priviledged access (e.g. e2fsck, mount) to stop running because the
> > > new capabilities _would_ have been granted by the new kernel and are
> > > not by the old kernel and STRICTXATTR is used.
> > > 
> > > To me it would seem that having extra capabilities on an old kernel
> > > is relatively harmless if the old kernel doesn't know what they are.
> > > It's like having a key to a door that you don't know where it is.
> > 
> > If we ditch the STRICTXATTR option do the semantics seem sane to you?
> 
> Seems reasonable.

It would simplify the code as well, which is good.

This does mean no sanity checking of fcaps, am not sure if that matters,
I'm guessing it should be similar to the case for other security attributes.

Regards
Suparna

> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

