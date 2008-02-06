Return-Path: <linux-kernel-owner+w=401wt.eu-S1761112AbYBFWpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761112AbYBFWpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbYBFWpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:45:33 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55533 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577AbYBFWpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:45:32 -0500
Date: Wed, 6 Feb 2008 16:45:27 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] unprivileged mounts: add sysctl tunable for
	"safe" property
Message-ID: <20080206224527.GB24246@sergelap.austin.ibm.com>
References: <20080205213616.343721693@szeredi.hu> <20080205213705.120219893@szeredi.hu> <20080206202110.GA20528@sergelap.ibm.com> <E1JMrXw-0000qq-O9@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JMrXw-0000qq-O9@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > +	t->table[0].mode = 0644;
> > 
> > Yikes, this could be a problem for containers, as it's simply tied to
> > uid 0, whereas tying it to a capability would let us solve it with
> > capability bounds.
> > 
> > This might mean more urgency to get user namespaces working at least
> > with sysfs, else this is a quick way around having CAP_SYS_ADMIN taken
> > out of a container's capability bounding set.
> 
> I think I understand the problem, but not the solution.  How do user
> namespaces going to help?

Well it somewhat depends on how we implement userns for filesystems
in the first place, and whether we end up splitting sysfs into
sub-filesystems as I think Eric Biederman has been advocating.  My
thoughts had been running along the lines of just tagging vfsmounts
with userns of the mounting process.  A task from outside the mounting
process' namespace would get user other permissions whether or not
its uid was the owning uid or uid 0 (unless the task had CAP_NS_OVERRIDE).

But really it gets more complicated for sysfs than something like ext2
since we really want to be able to filter files and directories for
different namespaces...  Handling sysfs user namespaces before we sort
out the rest of the sysfs stuff (being hashed out with network
namespaces) seems like jumping the gun a bit.

> Maybe sysctls just need to check capabilities, instead of uids.  I
> think that would make a lot of sense anyway.

Would it be as simple as tagging the inodes with capability sets?  One
set for writing, or one each for reading and writing?

thanks,
-serge
