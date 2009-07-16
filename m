Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbZGPUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbZGPUou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933324AbZGPUot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:44:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933323AbZGPUos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:44:48 -0400
Date: Thu, 16 Jul 2009 13:44:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc1-mmotm0702 - ps command hangs inside kernel
Message-Id: <20090716134401.0b1bec77.akpm@linux-foundation.org>
In-Reply-To: <1247775887.10888.17.camel@wall-e>
References: <47423.1247518491@turing-police.cc.vt.edu>
	<20090713143810.5e17bbdb.akpm@linux-foundation.org>
	<1247549479.30711.8.camel@wall-e>
	<46776.1247771564@turing-police.cc.vt.edu>
	<1247775887.10888.17.camel@wall-e>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 22:24:47 +0200
Stefani Seibold <stefani@seibold.net> wrote:

> On Thu, 16 Jul 2009, 15:12 -0400 Valdis.Kletnieks@vt.edu said:
> > On Tue, 14 Jul 2009 07:31:19 +0200, Stefani Seibold said:
> > > Am Montag, den 13.07.2009, 14:38 -0700 schrieb Andrew Morton:
> > > > On Mon, 13 Jul 2009 16:54:51 -0400
> > > > Valdis.Kletnieks@vt.edu wrote:
> > > > 
> > > > > Several times recently, I've had the 'ps' command hang inside the kernel
> > > > > for extended periods of time - usually around 1100 seconds, but today I
> > > > > had one that hung there for 2351 seconds.
> > 
> > > i am the author of the get_stack_usage_bytes(). Because i have currently
> > > no 64bit machine running, i am not able to analyse your problem. Does it
> > > only happen on 32bit application on a 64bit kernel? Is it only affected
> > > to pcsd?
> > 
> > I've only seen it happen to pcscd.  However, most of the time it's one of
> > the very few 32-bit apps running on my laptop (I've got exactly *one* legacy
> > app for a secure-token that is stuck in 32-bit land).  So I can't tell if it's
> > a generic 32-bit issue.
> > 
> > It's possible that one of the two follow_page() entries is stale and just
> > happened to be left on the stack.  A large chunk of proc_pid_status() is
> > inlined, so it's possible that two calls were made and left their return
> > addresses in different locations on the stack.
> > 
> > I am pretty sure that follow_page+0x28 is the correct one, as I see it
> > in 2 more tracebacks today (see below)...
> 
> The stack trace looks like you there is a old version included in the
> 2.6.31-rc1-mmotm0702 patches.
> 
> I switch to walk_page_range() function since patch version V0.9 dated
> from Jun 10 2009. Here is the link to the lkml patchwork:
>  
> http://patchwork.kernel.org/patch/32210/
> 
> I do the map examination exactly in the same way like the function used
> for /proc/<pid>/smaps. So i think this version should do it without side
> effects.
> 
> Can you tell me were you downloaded the 2.6.31-rc1-mmotm0702 patch?

It would have been version 08.  I've now updated to v11.
