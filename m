Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXBOSe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXBOSe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030489AbXBOSe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:34:26 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:52538 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030481AbXBOSeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:34:25 -0500
Date: Thu, 15 Feb 2007 19:33:52 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, davej@redhat.com, arjan@infradead.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing 
In-Reply-To: <32081.1171560770@redhat.com>
Message-ID: <Pine.LNX.4.64.0702151901380.14458@scrub.home>
References: <Pine.LNX.4.64.0702151530260.14458@scrub.home> 
 <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> 
 <32081.1171560770@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 15 Feb 2007, David Howells wrote:

> > This is really the weak point - it offers no advantage over an equivalent 
> > implementation in user space (e.g. in the module tools). So why has to be 
> > done in the kernel?
> 
> Because the init_module() system call is the common point of module submission
> to the kernel, not any particular userspace program.  There is no requirement
> for userspace to load a module by invoking a module tools program or library,
> and so userspace can bypass the checks entirely by just calling init_module().
> Assume for a moment that you can't trust userspace...  (Obviously, if you can't
> trust the kernel then you're already stuffed.)

All the security stuff in the kernel should provide the necessary means to 
restrict this system call.

> It is possible to protect /dev/mem and /dev/kmem or make them unavailable and
> it is possible to protect the kernel's memory whilst it is running (provided
> you don't have nommu or broken hardware and you don't let userspace concoct any
> DMA request it likes) which mostly closes those other vectors I mentioned.
> This isn't something I intended to look at with this patch.  Those are separate
> holes.

Exactly and as long as there are these holes, these patches are only 
kernel bloat. The simple verification can also be done in userspace and 
module signing offers no real security.
What real value do these patches provide, that can't be reached via other 
means? Who else than distributions would be interested in this? Pretty 
much any use you initially mentioned can be done in simpler ways, e.g. 
anyone afraid of modules simply disables module loading completely.

bye, Roman
