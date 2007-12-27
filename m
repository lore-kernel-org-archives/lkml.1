Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXL0Oyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXL0Oyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 09:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXL0Oyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 09:54:35 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37628 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbXL0Oyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 09:54:33 -0500
Date: Thu, 27 Dec 2007 08:54:31 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
Message-ID: <20071227145431.GB5161@sergelap.austin.ibm.com>
References: <200712252133.JFF05267.FOMFtOLJHSOVFQ@I-love.SAKURA.ne.jp> <20071226164230.GA14210@sergelap.austin.ibm.com> <200712272200.IIJ73936.OHOFFLMOQJVFtS@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712272200.IIJ73936.OHOFFLMOQJVFtS@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> Hello.
> 
> Thank you for feedback.
> 
> Serge E. Hallyn wrote:
> > > TOMOYO Linux is a DIY tool for understanding and protecting your system.
> > > TOMOYO Linux policy definitions are absolutely readable to Linux users, and
> > > TOMOYO Linux supports unique policy learning mechanism which automatically
> > 
> > Are they in fact unique?
> > 
> Yes, at least we believe so.

Ok I didn't mean that as criticism, but a real question :)
Auto-learning in itself doesn't seem novel, but so you're saying it's
novel in ust how integrated it is - no mnual intervention necessary?

> Have you ever heard an implementation that can automatically generate PIH
> and restrict the behavior based on PIH?
> Adding permissions to policy is not new because there is audit2allow
> that can do it. But adding domains (or PIH) to policy is new.

Does grsec's learning mode come closer to yours?  (I've never used
grsec, just got the impression it did a lot of auto-learning stuff)

> Here's our version of Linux security comparison table.
> http://tomoyo.sourceforge.jp/wiki-e/?WhatIs#comparison

hey that's a nice chart.  I'd link it explicitly from the doc...

> > What kernel resources does TOMOYO authorize?  All those which SELinux
> > does?
> TOMOYO can authorize part of kernel resources which SELinux can
> and part of other resources which SELinux can't.
>
> Currently, TOMOYO can authorize
> 
>   * execve() of programs.
>   * open() of files for reading/writing.
>   * creat()/link()/rename()/unlink()/symlink()/mkfifo()/mksock()/mkblock()/
>     mkchar()/truncate()/mkdir()/rmdir() of files and directries
>     that are visible to userland process's namespace.
>   * namespace manipulation. (i.e. mount()/umount()/pivot_root())

do you track mounts namespace cloning?

Well I don't see how you could without a new lsm hook  :)  But it seems
like something you'd need to really support this claim.  Any plans of
it?

>   * TCP/IP networking operations based on IPv4/v6 addresses and port numbers.
>     (Need to add LSM hooks for incoming connections/packets.)
>   * booleans for some operations. (Part of POSIX capability and TOMOYO's
>     original capability.)
>   * signal transmissions. (Needs to add LSM hooks.)
>   * argv[0] passed to execve().
>   * environment variables' names passed to execve().

Cool - by all means keep this list in your next version of this doc.

> > So your point was that your main goal is simplicity?
> Yes. Keep it understandable and customizable so that end users
> (i.e. administrators) can configure policy for their systems.
> 
> > 1. Tomoyo provide no sort of information flow control.
> Yes. TOMOYO is not intended to provide information flow control.
> Controlling information flow is not the region of interest for TOMOYO.
> (I'm not a security architect. I don't understand the definition and
> coverage of "information flow" in security field.
> I'm using "information flow" as "how information propagates".)

Right.

No need to defend it, not everyone needs it.  Just make it clear that
you don't care to support information flow control, then noone can
attack TOMOYO saying "it shouldn't be upstream bc it fails to provide
information flow control."

> I think no access control can guarantee regarding information flow.
> No access control can prevent attackers from leaking information
> which are caused by means granted to attackers.

I'd argue, but it's really not relevant right now  :)

> Even if some implementation can prevent attackers from leaking information
> regarding an atomic operation, it does not guarantee that the implementation
> can prevent attackers from leaking information as a whole system.
> Attackers can still do nasty requests within given permissions.
> But without these permissions, the system can't work properly.
> So, the region of interest for TOMOYO is how to minimize means granted to
> each PIH, although not all permissions TOMOYO can authorize.
> 
> > 2. TOMOYO is purely restrictive.
> Excuse me. What models are there other than "restrictive"?

capability and multi-admin can provide extra privilege to non-root
users.

> I'm not sure whether what TOMOYO is doing are categorized to
> "restrictive" model.
> 
> > 3. Learning mode is primary source of policy so you
> >    depend on change of behavior to detect intruders.
> >
> > 4. but any intruder who attempts to do something which
> >    the compomised sftware wouldn't have done should be
> >    stopped and detected.
> Yes. TOMOYO's power comes from "know all and understand what requests
> can happen within this system".

Cool.

thanks,
-serge
