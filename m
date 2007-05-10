Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbXEJUBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbXEJUBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbXEJUBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:01:30 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:39882 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXEJUB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:01:29 -0400
Date: Thu, 10 May 2007 13:01:27 -0700
From: Andreas Dilger <adilger@clusterfs.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>, jeffschroeder@computer.org,
       Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH 2/2] file capabilities: accomodate >32 bit capabilities
Message-ID: <20070510200127.GH6375@schatzie.adilger.int>
Mail-Followup-To: "Serge E. Hallyn" <serue@us.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	James Morris <jmorris@namei.org>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Andrew Morton <akpm@linux-foundation.org>,
	jeffschroeder@computer.org, Chris Wright <chrisw@sous-sol.org>,
	Karl MacMillan <kmacmillan@mentalrootkit.com>,
	KaiGai Kohei <kaigai@kaigai.gr.jp>
References: <20070508191548.GA29913@sergelap.austin.ibm.com> <20070508191704.GC29913@sergelap.austin.ibm.com> <20070508205826.GH6375@schatzie.adilger.int> <20070508214914.GA27582@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508214914.GA27582@sergelap.austin.ibm.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 08, 2007  16:49 -0500, Serge E. Hallyn wrote:
> Quoting Andreas Dilger (adilger@clusterfs.com):
> > One of the important use cases I can see today is the ability to
> > split the heavily-overloaded e.g. CAP_SYS_ADMIN into much more fine
> > grained attributes.
> 
> Sounds plausible, though it suffers from both making capabilities far
> more cumbersome (i.e. finding the right capability for what you wanted
> to do) and backward compatibility.  Perhaps at that point we should
> introduce security.capabilityv2 xattrs.  A binary can then carry
> security.capability=CAP_SYS_ADMIN=p, and
> security.capabilityv2=cap_may_clone_mntns=p.

Well, the overhead of each EA is non-trivial (16 bytes/EA) for storing
12 bytes worth of data, so it is probably just better to keep extending
the original capability fields as was in the proposal.

> > What we definitely do NOT want to happen is an application that needs
> > priviledged access (e.g. e2fsck, mount) to stop running because the
> > new capabilities _would_ have been granted by the new kernel and are
> > not by the old kernel and STRICTXATTR is used.
> > 
> > To me it would seem that having extra capabilities on an old kernel
> > is relatively harmless if the old kernel doesn't know what they are.
> > It's like having a key to a door that you don't know where it is.
> 
> If we ditch the STRICTXATTR option do the semantics seem sane to you?

Seems reasonable.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

