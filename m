Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbYEOTZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbYEOTZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYEOTZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:25:39 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:45120 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754324AbYEOTZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:25:38 -0400
X-YMail-OSG: HsDNlGgVM1mx1WNWWp.gO_arFS9mxK_5x0TrF6_EhdeVj7qTLisNp0acA9IZRC6XaT4xT6eh7hQXUQ.rJhq4VPvJLxDs2coZ9_E5uQ--
X-RocketYMMF: rancidfat
Date: Thu, 15 May 2008 12:25:34 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC][PATCH v2] security:  split proc ptrace checking into read vs. attach
To: Stephen Smalley <sds@tycho.nsa.gov>,
       lsm <linux-security-module@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1210877785.28282.131.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <913573.56827.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Enable security modules to distinguish reading of process state via
> proc from full ptrace access by renaming ptrace_may_attach to
> ptrace_may_access and adding a mode argument indicating whether only
> read access or full attach access is requested.  This allows security
> modules to permit access to reading process state without granting
> full ptrace access.  The base DAC/capability checking remains unchanged.
> 
> Read access to /proc/pid/mem continues to apply a full ptrace attach
> check since check_mem_permission() already requires the current task
> to already be ptracing the target.  The other ptrace checks within
> proc for elements like environ, maps, and fds are changed to pass the
> read mode instead of attach.
> 
> In the SELinux case, we model such reading of process state as a
> reading of a proc file labeled with the target process' label.  This
> enables SELinux policy to permit such reading of process state without
> permitting control or manipulation of the target process, as there are
> a number of cases where programs probe for such information via proc
> but do not need to be able to control the target (e.g. procps,
> lsof, PolicyKit, ConsoleKit).  At present we have to choose between
> allowing full ptrace in policy (more permissive than required/desired)
> or breaking functionality (or in some cases just silencing the denials
> via dontaudit rules but this can hide genuine attacks).
> 
> This version of the patch incorporates comments from Casey Schaufler
> (change/replace existing ptrace_may_attach interface, pass access
> mode), and Chris Wright (provide greater consistency in the checking).

Looks better to me.


Casey Schaufler
casey@schaufler-ca.com
