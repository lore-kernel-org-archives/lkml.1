Return-Path: <linux-kernel-owner+w=401wt.eu-S1763015AbYENP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763015AbYENP2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbYENP20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:28:26 -0400
Received: from sous-sol.org ([216.99.217.87]:35573 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYENP2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:28:25 -0400
Date: Wed, 14 May 2008 08:28:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>, casey@schaufler-ca.com,
       lsm <linux-security-module@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] security:  split ptrace checking in proc
Message-ID: <20080514152817.GC17453@sequoia.sous-sol.org>
References: <648615.23893.qm@web36601.mail.mud.yahoo.com> <1210687270.6206.129.camel@moss-spartans.epoch.ncsc.mil> <20080514091526.GB17453@sequoia.sous-sol.org> <1210762984.6206.293.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210762984.6206.293.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Smalley (sds@tycho.nsa.gov) wrote:
> On Wed, 2008-05-14 at 02:15 -0700, Chris Wright wrote:
> > It is slightly ad-hoc.  Is it just the audit messages that you described
> > that made you pick environ and fd, or was there more specific (threat
> > based) reasoning?  Would /proc/pid/fd/ + genfs + e.g. anonfd be a little
> > wider than just readstate?
> 
> Well, it is being driven by experience with what applications try to
> access w/o requiring full ptrace access, but also by a threat-based
> reasoning that it is less dangerous to grant limited read access to
> parts of the process state than to grant complete read access to its
> entire memory image or full control of the target process.
> 
> Not entirely sure what you mean by the latter question.

fd/ access gives a view in the ->files, which could include rather
internal bits like pipes, sockets, or anonfd descriptors -- things w/out
external handles.  That view includes ability to open the fd (similar
to dup()) and use it (granted subject to further security checks, but
they may be quite generic at that point).

thanks,
-chris
