Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXC2Ktw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXC2Ktw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 06:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXC2Ktw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 06:49:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4667 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030202AbXC2Ktv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 06:49:51 -0400
Date: Thu, 29 Mar 2007 10:49:37 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 1/4] coredump: add an interface to control the core dump routine
Message-ID: <20070329104936.GC5138@ucw.cz>
References: <45E7AAFA.4070402@hitachi.com> <45E7AC6F.8080704@hitachi.com> <20070302093419.GA2001@elf.ucw.cz> <4607C47B.2030909@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4607C47B.2030909@hitachi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have discussed with my colleagues why you say "ugly" against my
> procfs interface, then I noticed I may have misunderstood what you said.
> Is the reason for saying "ugly" two interfaces, i.e. preexisting ulimit
> (get/setrlimit) and my proc entry, exist to control core file size? 

Yes.

> > Plus, what you are doing can be done in userspace using google
> > coredumper.
> 
> I think that the needs differ between userland core dumper user and
> in-kernel core dumper user.  Pros and cons also differ.
> 
> Some of people (such as system admins, distro vendors, etc) need
> highly reliable core dumper because they don't want to experience
> same failures again and they don't hope that another failure is
> caused by core dumping.  Userland core dumper is useful because
> it is relatively easy to be customized, but its reliability highly
> depends on the application programs.

Fix userland core dumper to be reliable, then.

> If the stack for signal handlers is not set up carefully, if the
> data used by userland core dumper has been destroyed, if
> coredump_omit_anon_shared flag has been overwritten by bad data,
> or if the address of functions have been destroyed, the userland
> core dumper may fail to dump.  So in-kernel solutoin is required
> by enterprise users.

It should be possible to dump from separate process.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
