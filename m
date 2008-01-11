Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbYAKOrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbYAKOrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbYAKOq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:46:58 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58772 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764AbYAKOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:46:57 -0500
Date: Fri, 11 Jan 2008 09:46:56 -0500
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: indan@nul.nu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       w@1wt.eu, serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
Message-ID: <20080111144656.GL2310@csclub.uwaterloo.ca>
References: <47176.81.207.0.53.1199887192.squirrel@secure.samage.net> <200801100457.m0A4vcoi024209@www262.sakura.ne.jp> <36843.81.207.0.53.1200006346.squirrel@secure.samage.net> <200801110846.m0B8kIf7088823@www262.sakura.ne.jp> <38047.81.207.0.53.1200054134.squirrel@secure.samage.net> <200801112305.BII64642.tHOJSMLVQFFOOF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801112305.BII64642.tHOJSMLVQFFOOF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 11:05:07PM +0900, Tetsuo Handa wrote:
> Not only mknod() but also rename()/unlink()/link()/mount(bind) etc. that may
> cause filename/attribute mismatching.
> 
> How can the daemon know whether the request is trying to manipulate nodes
> in /dev directory or not?
> If "mount --bind /dev/ /var/dir/" is used, the daemon must check
> filename/attribute pair when mknod("/var/dir/null") is requested
> because permitting the request will modify /dev state.
> If "mount --bind /dev/ /var/dir/" is not used, the daemon must not check
> filename/attribute pair when mknod("/var/dir/null") is requested
> because permitting the request will not modify /dev state.
> 
> 
> 
> What does the daemon do? It receives requests from the LD_PRELOAD library
> using UNIX domain socket and checks filename/attribute pair and issue
> mknodat()/renameat()/unlinkat()/linkat() etc. when the combination is appropriate?
> 
> What does the LD_PRELOAD library do? It intercepts all pathname related syscalls
> (except open()) and solve directory component and determine whether the request is
> trying to manipulate nodes in /dev direcrtory and forward request to the daemon
> using UNIX domain socket?
> 
> "Make the daemon and the LD_PRELOAD library bug-and-race free and
> develop the MAC policy for the daemon and the LD_PRELOAD library"
> and "Make this filesystem bug-and-race free". Which one is easier?

I think a good question is:

What kind of idiot wrote a program that thinks it is allowed to go
messing with the contents of /dev?  There simply can't be a good reason
for an application to do that.  Device nodes should match up with
devices, so as long as the device nodes exist for all your devices, then
everything should just work and no one should ever have a reason to go
changing things for any reason.

Perhaps the real solution is a preload library that blocks the idiotic
program from touching anything in /dev with anything other than
open/close/read/write.

Of course it could also help to simply tell people what this stupid
program is actually doing and why it should be allowed to mess in places
it doesn't belong.

--
Len Sorensen
