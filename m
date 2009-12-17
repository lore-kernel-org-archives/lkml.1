Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbZLQD0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbZLQD0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 22:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbZLQD0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 22:26:34 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58570 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbZLQD0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 22:26:32 -0500
Subject: Re: Wrong atime on recent kernels
From: john stultz <johnstul@us.ibm.com>
To: Petr =?UTF-8?Q?Tit=C4=9Bra?= <petr@titera.eu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B29494B.4010305@titera.eu>
References: <4B26AB7E.9020208@titera.eu>
	 <1f1b08da0912141345ia574429k8b3e2fb73fdddb30@mail.gmail.com>
	 <4B29494B.4010305@titera.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 19:26:28 -0800
Message-ID: <1261020388.7245.27.camel@localhost.localdomain>
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
>
>     I did not test reverting this patch yet, because I did not find
> reliable way how to reproduce these strange modify times. But as I
> read your description. Would it be possible that if there would be bug
> in your patch i would be observer on mostly quiet system? I'm asking
> because full day of testing of the system under load did not produce
> any result, but then when I tried to run "find / | xargs stat" on idle
> system I've got several new instances of wrong access time (filesystem
> is mounted without noatime)

Another quick question:

What is the normal behavior you see when this issue is not cropping up?

Do you normally see all 0's in the ns field? Or do you expect to see an
actual ns value?

I'm asking as all the filesystems I've played with have all zeros, so
I'm not sure if I need to try a different filesystem (I tried ext4, but
it was with a disk that was originally ext3), or if the issue is just
the stray 1sec value in the ns field. 

thanks
-john


