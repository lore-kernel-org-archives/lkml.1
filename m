Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbXJCWX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbXJCWX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 18:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXJCWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 18:23:19 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:26370 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751491AbXJCWXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 18:23:18 -0400
X-YMail-OSG: KTycftkVM1nZRtZUFPACARX.HYmwrCwJ_HpkCSb1wdNkML77X8oSeh1HRZTVB2VLFzwiZnrg_g--
X-RocketYMMF: rancidfat
Date: Wed, 3 Oct 2007 15:23:15 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
To: Al Viro <viro@ftp.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, paul.moore@hp.com
In-Reply-To: <20071003205703.GM8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <493479.85198.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ftp.linux.org.uk> wrote:

> On Wed, Oct 03, 2007 at 12:51:08PM -0700, Casey Schaufler wrote:
> > > > Because you throw "simple" out the window when you require userland
> > > > assistance to perform this function.
> > > 
> > > Any more than having /tmp replaced with a symlink?
> > 
> > Yes. By the way, there's nothing that really requires that you
> > use a /smack symlink if you don't want to. /tmp can still be a
> > real directory, a mount point, a symlink to /var/tmp, or whatever
> > else you want it to be if that suits your needs better. For the
> > simplest scenarios /tmp -> /smack/tmp -> /moldy/<label> has every
> > other scheme I've seen throughly beaten.
> 
> And your point is?  If you don't use it, you get exact same complexity
> in both setups.

Thank you for your patience. Let me see if I can get my point across.

The intended Smack scenario:

1. Create /moldy at "_"
2. For each label you care about
   2a. Create /moldy/<label>
   2b. Set the label of /moldy/<label> to <label>
3. ln -s /smack/tmp /tmp

All processes are now redirected into the appropriate place
regardless of how they come into being. It doesn't matter if
the "session" starts from busybox, login, sshd, xdm, crontab,
or out of an init script.
  
> > > _What_ userland intervention?  Mounting stuff under /smack/tmp and not
> under
> > > your /moldy?
> > 
> > Who said anything about mounting under /moldy? I never did.
> 
> Sigh...  So put the binding into fstab and be done with that.

Are you suggesting that /smack/tmp.link below is a mount point,
and that appropriate directories get mounted there? 

1. Create /moldy at "_"
2. For each label you care about
   2a. Create /moldy/<label>
   2b. Set the label of /moldy/<label> to <label>
   2c. mount --bind /moldy/<label> /smack/tmp.link/<label>
3. ln -s /smack/tmp.link /tmp
  
> > > Having /tmp replaced with symlink to /smack/tmp.link instead
> > > of replacing it with a symlink to /smack/tmp?
> > > 
> > > Absolute paths in that kind of thing are _wrong_.  You know where the
> things
> > > are on your fs.  You don't know if anything else will be visible, let
> alone
> > > whether it will be at the same place in all chroots or namespaces.  And
> no,
> > > you _can't_ make sure that fs is visible only in one place.  No fs can or
> > > has any business even trying.
> > 
> > Is the objection that there is a default value coded in?
> 
> Right now the main objection is about your lack of ability to read.

Now you sound like my daughter. :-)

> Which
> part of "it can be mounted in different chroots/namespaces, therefore
> having absolute paths doesn't work" is too hard to understand?

It's the content of a symlink, and that can be just about anything
and is not required to point to anything, which is one reason why
I made that choice. If you don't have a /tmp, or can't write to the
/tmp that exists, or have a /tmp that's a dangling symlink under
any circumstances you may have an issue. That's true regardless of
the presence or absense of /smack. All of the traditional mechanisms
for dealing with /tmp in a chrooted or namespaced environment remain.

> No, it's not about having a default.

Nuts. That would have made addressing your concern easy.

> It's about keeping an absolute pathname in virtual fs,

It's in a symlink on the filesystem, and it doesn't have to be an
absolute pathname, although since it's a symlink and the semantics
for a symlink allow that be be absolute, relative, or dangling I
don't see any reason to restrict it from being absolute.

> having all instances autosoddingmatically sharing it _and_
> having change attempt in any instance automatically affect all of them.
> If you have that kind of sharing, don't pretend that your mechanism really
> allows absolute pathnames.

Could allowing multiple distinct mounts and symlink assignments
of /smackfs address those issues? I think it would, but as you pointed
out earlier, my lack of ability to read may be clouding my understanding.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
