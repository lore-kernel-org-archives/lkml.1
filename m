Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbXDBEhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbXDBEhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 00:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXDBEhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 00:37:55 -0400
Received: from smtp.knology.net ([24.214.63.101]:52838 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbXDBEhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 00:37:54 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 00:37:54 EDT
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
From: Dave Dillow <dave@thedillows.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org,
       Ingo Molnar <mingo@elte.hu>, amanda-hackers@amanda.org,
       amanda-users@amanda.org
In-Reply-To: <200704020021.02393.gene.heskett@gmail.com>
References: <200704010100.19016.gene.heskett@verizon.net>
	 <2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com>
	 <200704011141.53105.gene.heskett@verizon.net>
	 <200704020021.02393.gene.heskett@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Apr 2007 00:31:12 -0400
Message-Id: <1175488272.3161.28.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 00:20 -0400, Gene Heskett wrote:
> >From another email I sent Dave an hour or so ago:
> 
> For a good kernel, 2.6.20.3-rdsl-0.31:
> [root@coyote bad-kernel]# cd /usr/music
> [root@coyote music]# stat .
>   File: `.'
>   Size: 4096            Blocks: 16         IO Block: 4096   directory
> Device: fd00h/64768d    Inode: 10354963    Links: 39
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2007-04-01 21:07:14.000000000 -0400
> Modify: 2006-11-12 06:41:00.000000000 -0500
> Change: 2007-01-19 13:15:22.000000000 -0500
> [root@coyote music]#                                                               
> 
> Now rebooted to 2.6.21-rc5:
> [root@coyote ~]# cd /usr/music
> [root@coyote music]# stat .
>   File: `.'
>   Size: 4096            Blocks: 16         IO Block: 4096   directory
> Device: ee00h/60928d    Inode: 10354963    Links: 39
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2007-04-01 21:07:14.000000000 -0400
> Modify: 2006-11-12 06:41:00.000000000 -0500
> Change: 2007-01-19 13:15:22.000000000 -0500
> 
> What is this difference in the Device: line supposed to mean?
> 
> And are we 'getting warmer' here?

For those playing along at home, I believe the issue is that GNU tar
sees a different device number for the directories than what is listed
in the listed-incremental snapshot file, and thinks all of the
directories are new. I've asked Gene to make a few back-to-back runs of
the tar command under the same kernel to see if the subsequent runs
figure out that there's nothing to do, as expected.

Then it is a matter of figuring out why the device number changed -- I'm
thinking it is device-mapper, but will look closer tomorrow.
Dave
