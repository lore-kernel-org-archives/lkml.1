Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXLZWrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXLZWrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 17:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXLZWrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 17:47:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbXLZWrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 17:47:14 -0500
Date: Wed, 26 Dec 2007 14:46:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: Valdis.Kletnieks@vt.edu, Paul Moore <paul.moore@hp.com>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
Message-Id: <20071226144621.0220aece.akpm@linux-foundation.org>
In-Reply-To: <Xine.LNX.4.64.0712270059270.5765@us.intercode.com.au>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<30638.1198647786@turing-police.cc.vt.edu>
	<Xine.LNX.4.64.0712261833110.7815@us.intercode.com.au>
	<10809.1198657525@turing-police.cc.vt.edu>
	<Xine.LNX.4.64.0712261949060.10612@us.intercode.com.au>
	<Xine.LNX.4.64.0712270059270.5765@us.intercode.com.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007 01:16:25 +1100 (EST) James Morris <jmorris@namei.org> wrote:

> On Wed, 26 Dec 2007, James Morris wrote:
> 
> > What does the following say ?
> > 
> > # sestatus  && rpm -q selinux-policy
> 
> Don't worry about that -- I reproduced it with Paul Moore's git tree:
> git://git.infradead.org/users/pcmoore/lblnet-2.6_testing
> 
> (under current -mm, the e1000 driver doesn't find my ethernet card & the 
> tcl tests won't run without an external interface).

You might need to enable CONFIG_E1000E.

> The offending commit is when SELinux is converted to the new ifindex 
> interface:
> 
>   9c6ad8f6895db7a517c04c2147cb5e7ffb83a315 is first bad commit
>   commit 9c6ad8f6895db7a517c04c2147cb5e7ffb83a315
>   Author: Paul Moore <paul.moore@hp.com>
>   Date:   Fri Dec 21 11:44:26 2007 -0500
> 
>       SELinux: Convert the netif code to use ifindex values
> 
>       [...]
> 
> In some case (not yet fully identified -- also happens when avahi starts 
> up, although seemingly silently & without obvious issues), SELinux is 
> passed an ifindex of 1515870810, which corresponds to 0x5a5a5a5a, the slab 
> poison value, suggesting a race in the calling code where we're being 
> asked to check an skb which has been freed.
> 
> The SELinux code is erroring out before performing an access check 
> (perhaps there should be WARN_ON, at least), so this will affect both 
> permissive and enforcing mode without generating any log messages.
> 
> Andrew: I suggest dropping the patchset from -mm until Paul gets back from 
> vacation.

OK, thanks.
