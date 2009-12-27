Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZL0Ouh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZL0Ouh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZL0Oug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:50:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36446 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZL0Ouf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:50:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=QR-QLlQdE-oA:10 a=8pif782wAAAA:8 a=-IEdDE2Jt-ujtzoT0wcA:9 a=4qH19LK7SHJvj9WH7p141ty066oA:4
X-Cloudmark-Score: 0
X-Originating-IP: 70.124.57.33
Date: Sun, 27 Dec 2009 09:03:00 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: pavel@ucw.cz, viro@ZenIV.linux.org.uk, michael@laptop.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, andi@firstfloor.org,
       david@lang.hm, socketcan@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       herbert@gondor.apana.org.au, Valdis.Kletnieks@vt.edu, bdonlan@gmail.com,
       zbr@ioremap.net, cscott@cscott.net, jmorris@namei.org,
       ebiederm@xmission.com, bernie@codewiz.org, mrs@mythic-beasts.com,
       randy.dunlap@oracle.com, xiyou.wangcong@gmail.com, sam@synack.fr,
       casey@schaufler-ca.com, serue@us.ibm.com
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091227150300.GB19414@hallyn.com>
References: <20091227010441.GA12077@heat> <200912271736.GDB17180.OFJHOOQStMFLVF@I-love.SAKURA.ne.jp> <20091227083857.GC11737@elf.ucw.cz> <200912272049.FIB35755.OMFFOOJQtVLFSH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912272049.FIB35755.OMFFOOJQtVLFSH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> Pavel Machek wrote:
> > Syscalls are very wrong granularity for security system. But easy to
> > implement, see seccomp.
> 
> Quoting from http://en.wikipedia.org/wiki/Seccomp
> > It allows a process to make a one-way transition into a "secure" state where
> > it cannot make any system calls except exit(), read() and write() to
> > already-open file descriptors. 
> 
> I think seccomp() is too much restricted to apply for general applications.
> Most applications will need some other syscalls in addition to exit(), read()
> and write(). Most applications cannot use seccomp().
> 
> What I want to do is similar to seccomp(), but allows userland process to
> forbid some syscalls like execve(), mount(), chroot(), link(), unlink(),
> socket(), bind(), listen() etc. selectively.

The nice thing about the disablenetwork module is that (AFAICS so far)
it actually is safe for an unprivileged user to do.  I can't think of
any setuid-root software which, if started with restricted-network by
an unprivileged user, would become unsafe rather than simply failing (*1).

Adding syscalls becomes much scarier.

-serge

*1 - Michael Stone, without looking back over the patches, do you also
restrict opening netlink sockets?  Should we worry about preventing
an error message from being sent to the audit daemon?
