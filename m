Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbXJCTvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbXJCTvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXJCTvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:51:11 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:45614 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753559AbXJCTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:51:10 -0400
X-YMail-OSG: 7zbMo5QVM1kRBrsHgUsdYt79rMXZgZ0d6uenNYz8gRYPMAeNK4OKcojwnoL4MbtjM3bebS1_YA--
X-RocketYMMF: rancidfat
Date: Wed, 3 Oct 2007 12:51:08 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
To: Al Viro <viro@ftp.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, paul.moore@hp.com
In-Reply-To: <20071003175237.GK8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <975177.66265.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ftp.linux.org.uk> wrote:

> On Wed, Oct 03, 2007 at 10:21:08AM -0700, Casey Schaufler wrote:
> > > what
> > > happens if we want it in two chroot jails with different layouts?
> > 
> > As you can only have /smack mounted once, this isn't an issue,
> > but it does present an interesting use case that brings the one
> > mount limitation into question. I'll add addressing this to the
> > short term todo list.
> 
> Of course you can mount it more than once.  Just bind the sucker and you
> are done.
>  
> > > I really don't get it; why not simply have something like
> > > /smack/tmp.link resolve to tmp/<label> and have userland bind or mount
> > > whatever you bloody like on /smack/tmp?
> > 
> > Because you throw "simple" out the window when you require userland
> > assistance to perform this function.
> 
> Any more than having /tmp replaced with a symlink?

Yes. By the way, there's nothing that really requires that you
use a /smack symlink if you don't want to. /tmp can still be a
real directory, a mount point, a symlink to /var/tmp, or whatever
else you want it to be if that suits your needs better. For the
simplest scenarios /tmp -> /smack/tmp -> /moldy/<label> has every
other scheme I've seen throughly beaten.

> > I'm having some trouble seeing how the 60 lines of code in
> > smackfs dealing with symlinks would be improved by your suggestions.
> > I certainly don't see how requiring userland intervention would
> > do anything but make it bigger and less reliable.
> 
> _What_ userland intervention?  Mounting stuff under /smack/tmp and not under
> your /moldy?

Who said anything about mounting under /moldy? I never did.

> Having /tmp replaced with symlink to /smack/tmp.link instead
> of replacing it with a symlink to /smack/tmp?
> 
> Absolute paths in that kind of thing are _wrong_.  You know where the things
> are on your fs.  You don't know if anything else will be visible, let alone
> whether it will be at the same place in all chroots or namespaces.  And no,
> you _can't_ make sure that fs is visible only in one place.  No fs can or
> has any business even trying.

Is the objection that there is a default value coded in?


Casey Schaufler
casey@schaufler-ca.com
