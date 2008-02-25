Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYBYUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYBYUnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbYBYUnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:43:12 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44191 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685AbYBYUnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:43:11 -0500
Date: Mon, 25 Feb 2008 23:42:07 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Quigley <dpquigl@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Eric Paris <eparis@redhat.com>, Harald Welte <laforge@gnumonks.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kill_pid_info_as_uid: don't use security_task_kill()
Message-ID: <20080225204207.GA116@tv-sign.ru>
References: <1203965042.2804.196.camel@moss-spartans.epoch.ncsc.mil> <976891.59157.qm@web36608.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <976891.59157.qm@web36608.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Casey Schaufler wrote:
> 
> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > 
> > ...
> > > 
> > > I think we should omit the permission checks completely, the task which
> > does
> > > ioctl(USBDEVFS_SUBMITURB) explicitly asks to send the signal to it, we
> > should
> > > not deny the signal even if the task changes its credentials in any way.
> > 
> > If we are applying checks based on uid/gid to protect suid/sgid
> > programs, then we ought to also invoke the LSM hook to allow protection
> > of other credential-changing transformations, like SELinux context
> > transitions.  You either remove all checking or none, please.  And if
> > all, what's the rationale?
> 
> Perhaps more important to my mind is what lead the developers of
> this code to go to such significant lengths to provide this access
> check in the first place. Why was it considered sufficiently important?
> I concur that it's an ugly bit of hackery, but someone must have felt
> it was necessary or they wouldn't have done it.

Previously, USB used "pid_t pid" as a target for the signal. This pid
could be reused by the completely unrelated process, these checks ensure
that we at least doesn't kill the wrong user in this case.

Now we are using "struct pid", this means that the signal always goes
to the "right" task.

Oleg.

