Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXKGDKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXKGDKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbXKGDKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:10:23 -0500
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:46869 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755002AbXKGDKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:10:22 -0500
X-YMail-OSG: w6CorLcVM1mtycZOFPhFlgdm4AiO92_hy0rNVBK4nMyk9aavezwlZa7RtKnEub8YiYMdb5mcag--
X-RocketYMMF: rancidfat
Date: Tue, 6 Nov 2007 19:10:21 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] NetLabel: Introduce a new kernel configuration API for NetLabel - For 2.6.24-rc-git11 - Smack Version 10
To: Joshua Brindle <method@manicmethod.com>, casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, paul.moore@hp.com
In-Reply-To: <473119E6.7070904@manicmethod.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <570441.41117.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Joshua Brindle <method@manicmethod.com> wrote:

> Joshua Brindle wrote:
> > Casey Schaufler wrote:
> >> From: Paul Moore <paul.moore@hp.com>
> >>
> >> Add a new set of configuration functions to the NetLabel/LSM API so that
> >> LSMs can perform their own configuration of the NetLabel subsystem 
> >> without
> >> relying on assistance from userspace.
> >>   
> > I'm still not receiving the actual patch email on lsm (perhaps its too 
> > long and should be split up..) so I'll just respond on this email. 
> > Using the v10 patches on your website I'm still seeing strange 
> > behavior where echo foo > /proc/self/attr/current changes the label of 
> > every process on the system to foo (verified with both ps -AZ and cat 
> > /proc/1/attr/current).
> >
> Actually I'm getting more strange behavior:
> 
> On terminal 1 I do:
> echo foo > /proc/self/attr/current
> then ps -AZ shows foo for every process
> touch somefile; attr -S -g SMACK64 somefile says foo
> 
> On terminal 2 I do:
> ps -AZ and everything shows up as _
> cat /proc/$pid of bash on term 1/attr/current is _

Now this I can explain. Every task has it's own correct
label. The problem is a missing smack_getprocattr() hook.
ps is getting the value for "current" on the current process,
not that of the named process. Interestingly, the Smack label
of /proc/<xxx>/attr/current is correct.

So the fix is to put in the smack_getprocattr() hook.
Easily accomplished. Thank you for the informative and
helpful report.


Casey Schaufler
casey@schaufler-ca.com
