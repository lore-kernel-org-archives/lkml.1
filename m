Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYENPuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYENPuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYENPuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:50:32 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:34596 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYENPub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:50:31 -0400
Subject: Re: [RFC][PATCH] security:  split ptrace checking in proc
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Chris Wright <chrisw@sous-sol.org>
Cc: casey@schaufler-ca.com, lsm <linux-security-module@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080514152817.GC17453@sequoia.sous-sol.org>
References: <648615.23893.qm@web36601.mail.mud.yahoo.com>
	 <1210687270.6206.129.camel@moss-spartans.epoch.ncsc.mil>
	 <20080514091526.GB17453@sequoia.sous-sol.org>
	 <1210762984.6206.293.camel@moss-spartans.epoch.ncsc.mil>
	 <20080514152817.GC17453@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 14 May 2008 11:50:16 -0400
Message-Id: <1210780216.28282.4.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 08:28 -0700, Chris Wright wrote:
> * Stephen Smalley (sds@tycho.nsa.gov) wrote:
> > On Wed, 2008-05-14 at 02:15 -0700, Chris Wright wrote:
> > > It is slightly ad-hoc.  Is it just the audit messages that you described
> > > that made you pick environ and fd, or was there more specific (threat
> > > based) reasoning?  Would /proc/pid/fd/ + genfs + e.g. anonfd be a little
> > > wider than just readstate?
> > 
> > Well, it is being driven by experience with what applications try to
> > access w/o requiring full ptrace access, but also by a threat-based
> > reasoning that it is less dangerous to grant limited read access to
> > parts of the process state than to grant complete read access to its
> > entire memory image or full control of the target process.
> > 
> > Not entirely sure what you mean by the latter question.
> 
> fd/ access gives a view in the ->files, which could include rather
> internal bits like pipes, sockets, or anonfd descriptors -- things w/out
> external handles.  That view includes ability to open the fd (similar
> to dup()) and use it (granted subject to further security checks, but
> they may be quite generic at that point).

What do you mean by "generic" in the above?  Just the fact that there
wouldn't be any distinction between such access and access to a
descriptor received explicitly via local IPC from the target task?

Ok, so perhaps the only distinction that makes sense is read vs.
write/control, with all checks within proc except mem_write using the
former and ptrace_attach and mem_write using the latter?

-- 
Stephen Smalley
National Security Agency

