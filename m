Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbXEZQwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbXEZQwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXEZQwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:52:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:52323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbXEZQwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:52:33 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Tetsuo Handa <penguin-fsdevel@i-love.sakura.ne.jp>
Subject: Re: Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 26 May 2007 18:52:11 +0200
User-Agent: KMail/1.9.5
Cc: mrmacman_g4@mac.com, casey@schaufler-ca.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <200705261541.09891.agruen@suse.de> <200705262344.HGG92040.QtGFWFTOJMHOEFV@I-love.SAKURA.ne.jp>
In-Reply-To: <200705262344.HGG92040.QtGFWFTOJMHOEFV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261852.12065.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 16:44, Tetsuo Handa wrote:
> Hello.
>
> Andreas Gruenbacher wrote:
> > > Therefore, TOMOYO Linux checks the combination of filename and argv[0]
> > > passed to execve().
> >
> > So you are indeed trying to control the value of argv[0]? Well, good luck
> > with that, but it's totally insane. You are guaranteed to break some
> > applications.
>
> TOMOYO Linux restricts argv[0] using allow_argv0 syntax.

Alright, so it's configurable. This reduces it from being broken to being a 
truly bad idea.

> For example, an administrator may wish to allow users to run /bin/ls without
> applying profiles because /bin/ls won't read/write the content of files.

No, forget that line of reasoning. As soon as you run anything unconfined that 
isn't trusted, you have basically lost control. Relying on the fact 
that /bin/ls won't do any harm is assuming to much. Features might exist that 
allow it to be abused, new features might get added, or there may be bugs. 
Just don't do it.

Andreas
