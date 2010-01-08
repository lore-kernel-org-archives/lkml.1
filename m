Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571Ab0AHNPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab0AHNPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 08:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368Ab0AHNPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 08:15:14 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55477 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab0AHNPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 08:15:12 -0500
To: david@fromorbit.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.30 and later] file corruption on ext3 filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201001080254.o082sOXB018423@www262.sakura.ne.jp>
	<20100108123641.GB8654@discord.disaster>
In-Reply-To: <20100108123641.GB8654@discord.disaster>
Message-Id: <201001082215.EJH52647.JLtFSFFVQOHMOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 8 Jan 2010 22:15:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dave Chinner wrote:
> On Fri, Jan 08, 2010 at 11:54:24AM +0900, Tetsuo Handa wrote:
> > I'm experiencing file corruption problem.
> > Can somebody reproduce below result?
> > 
> > My environment:
> >   VMware Workstation 6.5.3 with 2CPUs / 512MB RAM.
> >   ext3 filesystem ( /dev/sda1 ) mounted on / .
> > 
> >   2.6.33-rc3 ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.33-rc3-ext3 )
> >   2.6.32.3   ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.32.3-ext3 )
> >   2.6.31.11  ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.31.11-ext3 )
> >   2.6.30.10
> > 
> >   So far, I haven't succeeded to reproduce this problem for 2.6.29 and earlier.
> >   Maybe this problem exists in only 2.6.30 and later.
> 
> Isn't that when the default mount options  changed from data=ordered to
> data=writeback?
Ah, indeed. 2.6.31 mounts data=writeback whereas 2.6.29 mounts data=ordered.

In my Ubuntu 9.10 environment, it is using data=writeback mode, and therefore
I got garbage data taken from other deleted files.

> You didn't fsync() it, so there is no reason for the kernel
> to have ever written it to disk. Therefore the result after powerfail
> is completely undefined - you data may be there, it may not...

I didn't call fsync(). Thus, I don't mind if the data I wrote is not written
to disk.

However, I feel something is very wrong because the file got data which I
didn't write. The file gets data from deleted files. Imagine that unprivileged
user can get the content of /etc/shadow if power failure occurred when the user
was running ./a.out .

The file should not get data from deleted files, but I can read the data from
deleted files by "cat /testfile". I feel something is very wrong.

Regards.
