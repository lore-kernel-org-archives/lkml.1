Return-Path: <linux-kernel-owner+w=401wt.eu-S1763782AbZLQBYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763782AbZLQBYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763725AbZLQBYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:24:37 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59424 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763738AbZLQBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:14 -0500
Subject: Re: Wrong atime on recent kernels
From: john stultz <johnstul@us.ibm.com>
To: Petr =?UTF-8?Q?Tit=C4=9Bra?= <petr@titera.eu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B29494B.4010305@titera.eu>
References: <4B26AB7E.9020208@titera.eu>
	 <1f1b08da0912141345ia574429k8b3e2fb73fdddb30@mail.gmail.com>
	 <4B29494B.4010305@titera.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 17:21:08 -0800
Message-ID: <1261012868.7245.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 21:55 +0100, Petr Titěra wrote:
> john stultz napsal(a): 
> > 2009/12/14 Petr Titěra <petr@titera.eu>:
> >   
> > > Hello,
> > > 
> > >      I see some strange file modification times recently. It seems to me
> > > that in some situations, kernel allows to set nanoseconds part of  file
> > > access, modification or change time  to 100000000 ns. Problem seems to be in
> > > some generic part of kernel because I see it on several different
> > > filesysytems (ext4 and nilf2). These is I've got during my testing on kernel
> > >  2.6.32-tip-08309-gad8e75a.
> > > 
> > >  File: `./Documentation/dvb/contributors.txt'
> > >  Size: 3035            Blocks: 8          IO Block: 4096   regular file
> > > Device: fe04h/65028d    Inode: 818         Links: 1
> > > Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> > > Access: 2009-12-14 10:29:04.1000000000 +0100
> > > Modify: 2009-12-14 10:29:04.1000000000 +0100
> > > Change: 2009-12-14 10:29:04.1000000000 +0100
> > > 
> > > See that all times of that file ends with 1e6 nanoseconds.
> > >     
> > 
> > Hrmmm. Does reverting this change solve it?
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=patch;h=7bc7d637452383d56ba4368d4336b0dde1bb476d
> > 
> > thanks
> > -john
> >   
> Hello,
> 
>     I did not test reverting this patch yet, because I did not find
> reliable way how to reproduce these strange modify times. But as I
> read your description. Would it be possible that if there would be bug
> in your patch i would be observer on mostly quiet system? I'm asking
> because full day of testing of the system under load did not produce
> any result, but then when I tried to run "find / | xargs stat" on idle
> system I've got several new instances of wrong access time (filesystem
> is mounted without noatime)

Yes, its possible it would be more likely to be seen on an idle system.

Can you describe your system to me?  Is it x86? x86_64? Could you send
your .config to me?

Please try to revert the patch, and I'll see if I can reproduce anything
similar on my systems.

thanks
-john


