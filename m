Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbXKSXQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbXKSXQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXKSXQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:16:45 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45882 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbXKSXQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:16:44 -0500
Date: Mon, 19 Nov 2007 17:16:44 -0600
From: "Serge E. Hallyn" <sergeh@us.ibm.com>
To: Chris Friedhoff <chris@friedhoff.org>
Cc: Serge E Hallyn <sergeh@us.ibm.com>, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>, Andrew Morgan <morgan@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Posix file capabilities in 2.6.24rc2; now 2.6.24-rc3
Message-ID: <20071119231644.GA26373@sergelap.austin.ibm.com>
References: <20071113230720.22c6a036.chris@friedhoff.org> <20071113235318.GA6477@sergelap.austin.ibm.com> <20071114101251.a1f6214d.chris@friedhoff.org> <20071114180235.GA25344@sergelap.austin.ibm.com> <20071115230227.9dabbb5f.chris@friedhoff.org> <20071119143946.b0664b6c.chris@friedhoff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119143946.b0664b6c.chris@friedhoff.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Friedhoff (chris@friedhoff.org):
> Hello Serge,
> 
> just to let you know: with 2.6.24-rc3 I have the same problem.

Ok, so here is the flow.

First off, using runlevel 5 on FC7, using 'log out' correctly brings
you back to a new login prompt.  Your problem is starting in runlevel
3, and typing 'xinit .xinitrc';  when you exit your wm, xinit is not
allowed to kill X so you don't get back to your console.

First comment is, as you point out on your homepage, you could
	setfcaps -c cap_kill+p -e /usr/bin/xinit
Then xinit is allowed to kill X.  Yes xinit forks and execs a
user-writable script, but of course upon the exec to start the script
cap_kill is lost, so the user can't abuse this.

Since you pointed this out on your homepage, I have to assume you've
decided you don't want to give cap_kill to xinit?

My other question is - do we want to maintain this signal restriction?
So long as a privileged process isn't dumpable, is it any more dangerous
for user hallyn to kill capability-raised process owned by hallyn than
it is to kill a setuid process started by hallyn?  If we decide no, then
maybe we should remove cap_task_kill() as well as the cap_task_setnice(),
cap_task_setioprio(), cap_task_setscheduler()?

Or maybe i've just forgotten a compelling scenario...

thanks,
-serge
