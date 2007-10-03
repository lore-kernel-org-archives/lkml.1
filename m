Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbXJCRwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbXJCRwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbXJCRwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:52:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57346 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbXJCRwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:52:43 -0400
Date: Wed, 3 Oct 2007 18:52:38 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, paul.moore@hp.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071003175237.GK8181@ftp.linux.org.uk>
References: <20071003051254.GH8181@ftp.linux.org.uk> <287091.73995.qm@web36604.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <287091.73995.qm@web36604.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 10:21:08AM -0700, Casey Schaufler wrote:
> > what
> > happens if we want it in two chroot jails with different layouts?
> 
> As you can only have /smack mounted once, this isn't an issue,
> but it does present an interesting use case that brings the one
> mount limitation into question. I'll add addressing this to the
> short term todo list.

Of course you can mount it more than once.  Just bind the sucker and you
are done.
 
> > I really don't get it; why not simply have something like
> > /smack/tmp.link resolve to tmp/<label> and have userland bind or mount
> > whatever you bloody like on /smack/tmp?
> 
> Because you throw "simple" out the window when you require userland
> assistance to perform this function.

Any more than having /tmp replaced with a symlink?

> I'm having some trouble seeing how the 60 lines of code in
> smackfs dealing with symlinks would be improved by your suggestions.
> I certainly don't see how requiring userland intervention would
> do anything but make it bigger and less reliable.

_What_ userland intervention?  Mounting stuff under /smack/tmp and not under
your /moldy?  Having /tmp replaced with symlink to /smack/tmp.link instead
of replacing it with a symlink to /smack/tmp?

Absolute paths in that kind of thing are _wrong_.  You know where the things
are on your fs.  You don't know if anything else will be visible, let alone
whether it will be at the same place in all chroots or namespaces.  And no,
you _can't_ make sure that fs is visible only in one place.  No fs can or
has any business even trying.
