Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYCERn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYCERn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYCERnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:43:18 -0500
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:28612 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756146AbYCERnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:43:17 -0500
X-YMail-OSG: HMSuOSAVM1mxESOjB0KY2McmhhoM3gD3lH89EshR_dNpfEFXT9F2BSj2C.F8Oe7Z3XCHCq1bbw--
X-RocketYMMF: rancidfat
Date: Wed, 5 Mar 2008 09:43:16 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH -v7 -rc3] Security: Introduce security= boot parameter
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Paul Moore <paul.moore@hp.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
In-Reply-To: <20080305165513.GA26419@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <406504.13718.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi Casey,
> 
> On Wed, Mar 05, 2008 at 08:33:34AM -0800, Casey Schaufler wrote:
> > 
> > --- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> > 
> ...
> > > 
> > > Do not let SMACK register smackfs if it was not chosen on
> > > boot. Smackfs assumes that smack hooks are registered and
> > > the initial task security setup (swapper->security) is done.
> > 
> > If the problem with initializing smackfs is because the
> > locks aren't initialized why not leave the lock initializations
> > in smack_init, and have them done before the check to see if the
> > smack LSM is going to get used? Really, we're only talking
> > about the case where a kernel is configured for testing or
> > development purposes, and the lock initialization can't
> > be considered a major impact in any case.
> > 
> 
> Beside the locking initialization issue, there's the current->security
> issue. smackfs init code code access current->security in 
> smk_unlbl_ambient().
> 
> As you know current->security may equal Null (Oops), or point to 
> another LSM structure that preceeded us in registration. 
> 
> The locking argument can't be applied here since we may override
> the other LSM tsk->security pointer this time.
> 
> Ofcourse all of the above points can be handleded by various
> if(current->security) checks + rechecking the read/write methods
> of each smackfs inode, but below only two lines will fix the 
> problem from its roots ;):
> 
> +	if (!security_module_enable(&smack_ops))
> +		return 0;
> 
> Is there a problem in the current approach that I'm not aware of ?

No, I made the common mistake of replying before I'd read all the
day's threads and didn't have all the information that you did.
Current LSM usage is really unfriendly to multiple "modules". I
don't see any problems with your current approach now that I've
dug into the issues a little further.

> You have your veto in this issue at the end ;)

I suppose, although that would be really stoopid when you're
doing all the hard work. Thank you.


Casey Schaufler
casey@schaufler-ca.com
