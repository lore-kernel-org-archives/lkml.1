Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZDPPfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZDPPfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZDPPfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:35:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40106 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbZDPPe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m7Z7UIOQdf3MgXqBKtFptu3ZmKfwoY45K5+Ec9HTRxBO88HKFtvWVYQESy/xRhyaCG
         Me2TmSqfrwXP3VA/1GdAZl20A/c+2IVe8Gu22Aj33k1OzVDuj9Bj2rnPyBn6Xu4kPLMs
         QYrKehNAnYMmbOTmmyAPkbbjUGcrn5gPzEgBw=
Date: Thu, 16 Apr 2009 19:35:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       xemul@parallels.com, containers@lists.linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: CAP_SYS_ADMIN on restart(2)
Message-ID: <20090416153513.GA7876@x200.localdomain>
References: <49E4108A.8050201@cs.columbia.edu> <20090414145830.GA27461@x200.localdomain> <49E4D115.5080601@cs.columbia.edu> <20090414204912.GA28458@x200.localdomain> <20090414213934.GB17986@us.ibm.com> <20090415192150.GC26994@x200.localdomain> <1239827033.32604.167.camel@nimitz> <20090415203920.GA5475@us.ibm.com> <49E64BFF.5080002@cs.columbia.edu> <20090415211609.GA6704@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415211609.GA6704@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 04:16:09PM -0500, Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@cs.columbia.edu):
> > 
> > 
> > Serge E. Hallyn wrote:
> > > Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> > >> On Wed, 2009-04-15 at 23:21 +0400, Alexey Dobriyan wrote:
> > >>> Is sysctl to control CAP_SYS_ADMIN on restart(2) OK?
> > >> If the point is not to let users even *try* restarting things if it
> > >> *might* not work, then I guess this might be reasonable.  
> > >>
> > >> If the goal is to increase security by always requiring CAP_SYS_ADMIN
> > >> for "dangerous" operations, I fear it will be harmful.  We may have
> > >> people adding features that are not considering the security impact of
> > >> what they're doing just because the cases they care about all require
> > >> privilege.
> > > 
> > > Nah, I disagree.  (Or put another way, that wouldn't be the goal)
> > > There are two administrators we want to satisfy:
> > > 
> > > 1. the one who wants his users to do partial checkpoints, but doesn't
> > > want to risk giving away any privilege at all in the process.  He'll
> > > be satisified by setting restart(2) to not require cap_sys_admin,
> > > and his users just won't be able to do a whole container.  A lot of
> > > users will be happy with that (though no SYSVIPC support, then).
> > 
> > There is also a middle way: use setuid program to allow creation
> > of a new namespace (under your favorite policy), then drop the
> > privileges and continue as unprivileged inside that container.
> > 
> > IOW, don't make the initial container-creation a barrier for the
> > entire operation.
> 
> That is still possible here.  But I don't think it's relevant.
> 
> What Alexey wants, I believe, is for users to be able to not have
> to worry about there being exploitable bugs in restart(2) which
> unprivileged users can play with.  And for the usual distro-kernel
> reasons, saying use 'CONFIG_CHECKPOINT=n' is not an option.

This is correct, yes. If I would be a sysadmin who knows a bit about
kernel internals, I'd never trust restart(2) to get it right.
