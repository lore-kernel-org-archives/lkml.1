Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXKTJrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXKTJrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbXKTJrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:47:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:59247 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXKTJrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:47:00 -0500
Date: Tue, 20 Nov 2007 10:46:09 +0100
From: Chris Friedhoff <chris@friedhoff.org>
To: Serge E Hallyn <sergeh@us.ibm.com>
Cc: "chris@friedhoff.org" <chris@friedhoff.org>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>, Andrew Morgan <morgan@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Posix file capabilities in 2.6.24rc2; now 2.6.24-rc3
Message-Id: <20071120104609.d4f13fa0.chris@friedhoff.org>
In-Reply-To: <20071119231644.GA26373@sergelap.austin.ibm.com>
References: <20071113230720.22c6a036.chris@friedhoff.org>
	<20071113235318.GA6477@sergelap.austin.ibm.com>
	<20071114101251.a1f6214d.chris@friedhoff.org>
	<20071114180235.GA25344@sergelap.austin.ibm.com>
	<20071115230227.9dabbb5f.chris@friedhoff.org>
	<20071119143946.b0664b6c.chris@friedhoff.org>
	<20071119231644.GA26373@sergelap.austin.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.10.14; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX184B8K0XfL3h9UD88x5XDQ70+L2Rw0N0cQzjPK
 YE2cp+oN+yltWSLY2goWAVpZgRNLDKFc847aDRvpydfojLw5KQ
 MzoF3rrt5KUkM1l91nzbn39+4PD4v+6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 17:16:44 -0600
"Serge E. Hallyn" <sergeh@us.ibm.com> wrote:

> Quoting Chris Friedhoff (chris@friedhoff.org):
> > Hello Serge,
> > 
> > just to let you know: with 2.6.24-rc3 I have the same problem.
> 
> Ok, so here is the flow.
> 
> First off, using runlevel 5 on FC7, using 'log out' correctly brings
> you back to a new login prompt.  Your problem is starting in runlevel
> 3, and typing 'xinit .xinitrc';  when you exit your wm, xinit is not
> allowed to kill X so you don't get back to your console.

Yes, I'm booting in a runlevel without a session manager and starting
my X session with xinit.
(slackware: console->runlevel 3; sessionmanager->runlevel 4 )

> 
> First comment is, as you point out on your homepage, you could
> 	setfcaps -c cap_kill+p -e /usr/bin/xinit
> Then xinit is allowed to kill X.  Yes xinit forks and execs a
> user-writable script, but of course upon the exec to start the script
> cap_kill is lost, so the user can't abuse this.
> 
> Since you pointed this out on your homepage, I have to assume you've
> decided you don't want to give cap_kill to xinit?

No, since I'm using capabilities and I'm very happy with it, I grant
cap_kill to xinit. For myself the problem is solved ...

> 
> My other question is - do we want to maintain this signal restriction?
> So long as a privileged process isn't dumpable, is it any more dangerous
> for user hallyn to kill capability-raised process owned by hallyn than
> it is to kill a setuid process started by hallyn?  If we decide no, then
> maybe we should remove cap_task_kill() as well as the cap_task_setnice(),
> cap_task_setioprio(), cap_task_setscheduler()?
> 
> Or maybe i've just forgotten a compelling scenario...
> 
> thanks,
> -serge


... but if some user decides to configure capabilities into the 2.6.24
kernel or just uses such a kernel and
1) is not granting cap_kill to xinit, and
2) starts X by issuing xinit on the console
3) ends after some time his X session, to come back to the console

he will see a different behavior compared to 2.6.23 exiting his X
session and (I think) believes to have a bug in the X package.

Andrew Morton describes the problem here, too:
http://lkml.org/lkml/2006/11/23/15
http://lkml.org/lkml/2006/11/23/19

Am I wrong in the assumption, but should one not accept an unchanged
behavior with or without capabilities in the kernel regarding the
behavior of applications, when he is not actually using (by not setting
the xattr capability) capabilities with this application?

If I'm wrong, maybe a warning or hint should be given that one has to
grant cap_kill to xinit to come back to the console if the X session
was started by xinit.


Chris



--------------------
Chris Friedhoff
chris@friedhoff.org
