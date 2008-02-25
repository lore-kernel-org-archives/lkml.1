Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYBYUYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYBYUYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYBYUXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:23:55 -0500
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:39879 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751841AbYBYUXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:23:55 -0500
X-YMail-OSG: zZNWKBcVM1kXpMlMSjw3BLPUIV7mHNhwsIKIo5UKDMXF7S23aFB6BQO7TU7iCAPfbx685icw4Q--
X-RocketYMMF: rancidfat
Date: Mon, 25 Feb 2008 12:23:53 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 2/3] kill_pid_info_as_uid: don't use security_task_kill()
To: Stephen Smalley <sds@tycho.nsa.gov>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Quigley <dpquigl@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Eric Paris <eparis@redhat.com>, Harald Welte <laforge@gnumonks.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1203965042.2804.196.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <976891.59157.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> 
> ...
> > 
> > I think we should omit the permission checks completely, the task which
> does
> > ioctl(USBDEVFS_SUBMITURB) explicitly asks to send the signal to it, we
> should
> > not deny the signal even if the task changes its credentials in any way.
> 
> If we are applying checks based on uid/gid to protect suid/sgid
> programs, then we ought to also invoke the LSM hook to allow protection
> of other credential-changing transformations, like SELinux context
> transitions.  You either remove all checking or none, please.  And if
> all, what's the rationale?

Perhaps more important to my mind is what lead the developers of
this code to go to such significant lengths to provide this access
check in the first place. Why was it considered sufficiently important?
I concur that it's an ugly bit of hackery, but someone must have felt
it was necessary or they wouldn't have done it.


Casey Schaufler
casey@schaufler-ca.com
