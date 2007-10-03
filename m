Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXJCU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXJCU5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbXJCU5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:57:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49459 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbXJCU5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:57:08 -0400
Date: Wed, 3 Oct 2007 21:57:03 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, paul.moore@hp.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071003205703.GM8181@ftp.linux.org.uk>
References: <20071003175237.GK8181@ftp.linux.org.uk> <975177.66265.qm@web36601.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <975177.66265.qm@web36601.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 12:51:08PM -0700, Casey Schaufler wrote:
> > > Because you throw "simple" out the window when you require userland
> > > assistance to perform this function.
> > 
> > Any more than having /tmp replaced with a symlink?
> 
> Yes. By the way, there's nothing that really requires that you
> use a /smack symlink if you don't want to. /tmp can still be a
> real directory, a mount point, a symlink to /var/tmp, or whatever
> else you want it to be if that suits your needs better. For the
> simplest scenarios /tmp -> /smack/tmp -> /moldy/<label> has every
> other scheme I've seen throughly beaten.

And your point is?  If you don't use it, you get exact same complexity
in both setups.
 
> > _What_ userland intervention?  Mounting stuff under /smack/tmp and not under
> > your /moldy?
> 
> Who said anything about mounting under /moldy? I never did.

Sigh...  So put the binding into fstab and be done with that.
 
> > Having /tmp replaced with symlink to /smack/tmp.link instead
> > of replacing it with a symlink to /smack/tmp?
> > 
> > Absolute paths in that kind of thing are _wrong_.  You know where the things
> > are on your fs.  You don't know if anything else will be visible, let alone
> > whether it will be at the same place in all chroots or namespaces.  And no,
> > you _can't_ make sure that fs is visible only in one place.  No fs can or
> > has any business even trying.
> 
> Is the objection that there is a default value coded in?

Right now the main objection is about your lack of ability to read.  Which
part of "it can be mounted in different chroots/namespaces, therefore
having absolute paths doesn't work" is too hard to understand?

No, it's not about having a default.  It's about keeping an absolute pathname
in virtual fs, having all instances autosoddingmatically sharing it _and_
having change attempt in any instance automatically affect all of them.
If you have that kind of sharing, don't pretend that your mechanism really
allows absolute pathnames.
