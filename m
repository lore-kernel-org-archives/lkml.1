Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbXJSUZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbXJSUZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759531AbXJSUYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:24:50 -0400
Received: from mail.suse.de ([195.135.220.2]:45312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761351AbXJSUYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:24:49 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
Date: Fri, 19 Oct 2007 22:26:53 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192226.53233.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 04:18, Linus Torvalds wrote:
> On Wed, 17 Oct 2007, Thomas Fricaccia wrote:
> > 
> > But then I noticed that, while the LSM would remain in existence, it was 
> > being closed to out-of-tree security frameworks.  Yikes!  Since then, 
> > I've been following the rush to put SMACK, TOMOYO and AppArmor 
> > "in-tree".
> 
> Yeah, it did come up. Andrew, when he sent it on to me, said that the SuSE 
> people were ok with it (AppArmor), but I'm with you - I applied it, but 
> I'm also perfectly willing to unapply it if there actually are valid 
> out-of-tree users that people push for not merging.

The patch doesn't hurt AppArmor, but it's still a step in the wrong direction.

Quoting from commit 20510f2f (Convert LSM into a static interface):
> In a nutshell, there is no safe way to unload an LSM.  The modular interface
> is thus unecessary and broken infrastructure.  It is used only by
> out-of-tree modules, which are often binary-only, illegal, abusive of the
> API and dangerous, e.g.  silently re-vectoring SELinux.

This is idiotic. Just because there is no safe way to unload SELinux

 - doesn't mean there is no safe way to unload other LSMs: if nothing
   but that, unloading is handy during development.

 - doesn't mean that module *loading* is unsafe. The patch removes module
   loading as well, which hurts more than removing module unloading.

LSM can be abused ... so what, this doesn't mean the interface is bad. Non-LSM 
loadable modules have been known to do lots of bad things, and yet nobody 
made them non-loadable either (yet).

> [...]
> For example, I do kind of see the point that a "real" security model might 
> want to be compiled-in, and not something you override from a module.

Non-trivial modules (i.e., practically everything beyond capabilities) become 
effective only after loading policy, anyway. If you can load policy, you can 
as well first load a security module without making the system insecure.

Thanks,
Andreas
