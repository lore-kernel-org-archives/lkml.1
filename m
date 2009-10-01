Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZJAHi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZJAHi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZJAHi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:38:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59079 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbZJAHi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:38:58 -0400
Date: Thu, 1 Oct 2009 09:38:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andy Spencer <andy753421@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Privilege dropping security module
Message-ID: <20091001073853.GA1330@ucw.cz>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <4ABA892A.9090804@schaufler-ca.com> <20090923223110.GA1449@c.hsd1.tn.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923223110.GA1449@c.hsd1.tn.comcast.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-23 22:31:10, Andy Spencer wrote:
> > Hi Andy. Git is a wonderful tool, but if you want people to review
> > your work you need to post patches.
> 
> Thanks for letting me know, I've posted a separate message with patch.
> 
> 
> > And what do you propose as an interesting use case for dpriv?
> 
> I think the two most important things about dpriv is that it can be used
> by ordinary users and that is can create policies programmatically.
> 
> Being able to use dpriv as a non root user is pretty strait forward. For
> example, a user of a multi-user system may want to try some untrusted
> code without risking access to the rest of the system:
> 
>   $ cd ~/my_project
>   $ echo rxRX   /                > /sys/kernel/security/dpriv/stage
>   $ echo X      $HOME            > /sys/kernel/security/dpriv/stage
>   $ echo rwxRWX $HOME/my_project > /sys/kernel/security/dpriv/stage
>   $ echo commit                  > /sys/kernel/security/dpriv/control
>   $ patch < untrusted.patch
>   $ make && ./src/some_exe

Yeah, and now your ~/.ssh/identity is being uploaded to remote server.

I believe people are already sandboxing apps with selinux...

...and subterfugue certainly does what you want, using
ptrace... no kernel mods needed and should already be secure.

								Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
