Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbXJ1R7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbXJ1R7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbXJ1R7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:59:30 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2206 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbXJ1R72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:59:28 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] proc_fs.h redux
Date: Sun, 28 Oct 2007 19:58:22 +0200
User-Agent: KMail/1.9.7
Cc: Joe Perches <joe@perches.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org, torvalds@osdl.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20071027194758.GD9816@martell.zuzino.mipt.ru> <1193524804.26695.103.camel@localhost> <20071028103415.GA12554@flint.arm.linux.org.uk>
In-Reply-To: <20071028103415.GA12554@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710281858.23705.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 28 October 2007, Russell King wrote:

> On Sat, Oct 27, 2007 at 03:40:04PM -0700, Joe Perches wrote:
> > and forward declarations of
> >
> > struct proc_dir_entry;
> > struct file_operations;
> >
> > As a general rule, I think it better to use includes
> > than use naked forward declarations.
>
> If you go down that route, you end up with _lots_ of circular
> dependencies - header file X needs Y needs Z which needs X.  We've
> been there, several times.  It very quickly becomes quite
> unmaintainable - you end up with hard to predict behaviour from
> include files.
>
> The only realistic solution is to use forward declarations.

It's unfortunately more complicated than that. What basically needs to be done 
is to separate declarations from its users (usually inline functions). The 
problem is to correctly pull the declarations from the <asm/...> and 
<linux/...> header in the correct order. A typical mistake is to put 
declarations and inline functions in the same linux header and then include 
some additional from an asm header. For most high level header it's not much 
of a problem, but let's take <linux/list.h> as example. struct list_head is 
used everywhere, but just to get this one definition one also gets quite a 
few other dependencies as well.

bye, Roman
