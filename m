Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbYENLDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbYENLDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYENLD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:03:29 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:47791 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbYENLD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:03:28 -0400
Subject: Re: [RFC][PATCH] security:  split ptrace checking in proc
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Chris Wright <chrisw@sous-sol.org>
Cc: casey@schaufler-ca.com, lsm <linux-security-module@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080514091526.GB17453@sequoia.sous-sol.org>
References: <648615.23893.qm@web36601.mail.mud.yahoo.com>
	 <1210687270.6206.129.camel@moss-spartans.epoch.ncsc.mil>
	 <20080514091526.GB17453@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 14 May 2008 07:03:04 -0400
Message-Id: <1210762984.6206.293.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 02:15 -0700, Chris Wright wrote:
> * Stephen Smalley (sds@tycho.nsa.gov) wrote:
> > As above, it isn't quite a read vs. readwrite mode distinction (which is
> > why I called it ptrace_may_readstate rather than just ptrace_may_read),
> > and the advantage of implementing it via a new interface is that we only
> > need to update the callers where we want to apply this different
> > checking, leaving all other callers unmodified and unaffected.  So while
> > I could do it the way you describe, I'm not sure it would yield a better
> > result.  Maybe others can chime in with their opinions.
> 
> It is slightly ad-hoc.  Is it just the audit messages that you described
> that made you pick environ and fd, or was there more specific (threat
> based) reasoning?  Would /proc/pid/fd/ + genfs + e.g. anonfd be a little
> wider than just readstate?

Well, it is being driven by experience with what applications try to
access w/o requiring full ptrace access, but also by a threat-based
reasoning that it is less dangerous to grant limited read access to
parts of the process state than to grant complete read access to its
entire memory image or full control of the target process.

Not entirely sure what you mean by the latter question.

> Perhaps you could update the comments in ptrace_may_inspect() to clarify.

Ok, will do.

-- 
Stephen Smalley
National Security Agency

