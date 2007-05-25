Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbXEYRn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbXEYRn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762849AbXEYRnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:43:49 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:43621 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752281AbXEYRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:43:48 -0400
X-YMail-OSG: 4AP15u4VM1llkxan7.Yur0KTvnCZC5Z_RlhIcvoAPGO4IvhNM4KyPTG39NM1Pgdm0Q.NWFwOIQ--
X-RocketYMMF: rancidfat
Date: Fri, 25 May 2007 10:43:47 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: Andreas Gruenbacher <agruen@suse.de>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <87lkfdpjm7.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <267570.85171.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jeremy Maitin-Shepard <jbms@cmu.edu> wrote:

> Casey Schaufler <casey@schaufler-ca.com> writes:
> 
> > On Fedora zcat, gzip and gunzip are all links to the same file.
> > I can imagine (although it is a bit of a stretch) allowing a set
> > of users access to gunzip but not gzip (or the other way around).
> > There are probably more sophisticated programs that have different
> > behavior based on the name they're invoked by that would provide
> > a more compelling arguement, assuming of course that you buy into
> > the behavior-based-on-name scheme. What I think I'm suggesting is
> > that AppArmor might be useful in addressing the fact that a file
> > with multiple hard links is necessarily constrained to have the
> > same access control on each of those names. That assumes one
> > believes that such behavior is flawwed, and I'm not going to try
> > to argue that. The question was about an example, and there is one.
> 
> This doesn't work.  The behavior depends on argv[0], which is not
> necessarily the same as the name of the file.

Sorry, but I don't understand your objection. If AppArmor is configured
to allow everyone access to /bin/gzip but only some people access to
/bin/gunzip and (important detail) the single binary uses argv[0]
as documented and (another important detail) there aren't other links
named gunzip to the binary (ok, that's lots of if's) you should be fine.
I suppose you could make a shell that lies to exec, but the AppArmor
code could certainly check for that in exec by enforcing the argv[0]
convention. It would be perfectly reasonable for a system that is so
dependent on pathnames to require that.


Casey Schaufler
casey@schaufler-ca.com
