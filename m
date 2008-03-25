Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYCYNk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYCYNk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYCYNkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:40:21 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48141 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbYCYNkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:40:19 -0400
Date: Tue, 25 Mar 2008 08:40:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <morgan@kernel.org>
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080325134001.GB5984@sergelap.austin.rr.com>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz> <20080324230458.GA173@tv-sign.ru> <1206446637.3302.134.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206446637.3302.134.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> 
> On Tue, 2008-03-25 at 02:04 +0300, Oleg Nesterov wrote:
> > On 03/24, Pavel Machek wrote:
> > >
> > > > /sbin/init is important, but there are other important (and sometimes
> > > > much more important) services. Why it is so special so that we can't
> > > > debug/strace it?
> > > 
> > > Maybe. Let's kill /sbin/init protection in 2.6.26. But making it
> > > optional is wrong.
> > 
> > You are right, the boot parameter is silly. How about sysctl?
> > 
> > Stephen, do you see any security problems if we make /sbin/init
> > ptraceable by default?
> 
> Not an issue for SELinux (we apply an orthogonal check based on security
> context, so we can already block ptrace of init independent of whether
> root/CAP_SYS_PTRACE can do it).  I'm not sure though as to whether
> people using capabilities have ever relied on this special protection of
> init (e.g. custom init spawns children with lesser capabilities and
> relies on the fact that they cannot ptrace init to effectively re-gain
> those capabilities, even if they possess CAP_SYS_PTRACE).

Still thinking it through, but it seems like special casing init isn't
useful.  There are likely to be other tasks with all capabilities
set which the malicious task could just as well ptrace to do his
mischief, right?

thanks,
-serge
