Return-Path: <linux-kernel-owner+w=401wt.eu-S1751122AbXDFFeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbXDFFeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 01:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXDFFeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 01:34:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:1538 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbXDFFeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 01:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=saUK2Ld1/6h3C7xQO5vTcaQMhqTXdGt5j83dwHQ5ynlhycwZuThYiOokRT3PgDANsFmDEy6EuKUHFdfKFMxkr/MF21O1Nannq1IG1r9n8FTSyASg2tIny14D8YxfllFhBVA8vr8xxlQFAO9jOlaTcXjvKUq+eX6vMatWZYtAq2I=
Message-ID: <e9c3a7c20704052234w27727979xb7958a1e0011c6b1@mail.gmail.com>
Date: Thu, 5 Apr 2007 22:34:20 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: RAID1 "out of memory" error, was Re: 2.6.21-rc5-mm4
Cc: "Reuben Farrelly" <reuben-linuxkernel@reub.net>, neilb@suse.de,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20070405132148.04d01bad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <461524BF.7050304@reub.net>
	 <20070405132148.04d01bad.akpm@linux-foundation.org>
X-Google-Sender-Auth: d759e0e504191751
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 06 Apr 2007 02:33:03 +1000
> Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:
>
> > Hi,
> >
> > On 3/04/2007 3:47 PM, Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > >
> > > - The oops in git-net.patch has been fixed, so that tree has been restored.
> > >   It is huge.
> > >
> > > - Added the device-mapper development tree to the -mm lineup (Alasdair
> > >   Kergon).  It is a quilt tree, living at
> > >   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> > >
> > > - Added davidel's signalfd stuff.
> >
> > Looks like some damage, or maybe intolerance to on-disk damage, to RAID-1.
> >
> > md1 is the first array on the disk, and it refuses to start up on boot, or after
> > boot.
> >
> > ...
> >
> > tornado ~ # mdadm --assemble /dev/md1 /dev/sda1 /dev/sdc1
> > mdadm: device /dev/md1 already active - cannot assemble it
> > tornado ~ # mdadm --run /dev/md1
> > mdadm: failed to run array /dev/md1: Cannot allocate memory
> > tornado ~ #
> >
> > and looking at a dmesg, this is logged:
> >
> > md: bind<sdc1>
> > md: bind<sda1>
> > raid1: raid set md1 active with 2 out of 2 mirrors
> > md1: bitmap initialized from disk: read 0/1 pages, set 0 bits, status: -12
> > md1: failed to create bitmap (-12)
> > md: pers->run() failed ...

Is this the dmesg from boot or the dmesg after running the mdadm --run command?

> >
> > tornado ~ # uname -a
> > Linux tornado 2.6.21-rc5-mm4 #1 SMP Thu Apr 5 23:47:42 EST 2007 x86_64 Intel(R)
> > Pentium(R) 4 CPU 3.00GHz GenuineIntel GNU/Linux
> > tornado ~ #
> >
> > The last known version that worked was 2.6.21-rc3-mm1 - I haven't been testing
> > out the -mm releases so much lately.
>
> OK.  I assume that bitmap->chunks in bitmap_init_from_disk() has some
> unexpectedly large value.
>
> I don't _think_ there's anything in -mm which would have triggered this.
> Does mainline do the same thing?
>
> I guess it's possible that the code in git-md-accel.patch accidentally
> broke things.  Perhaps try disabling CONFIG_DMA_ENGINE?
>

git-md-accel.patch does not touch anything in the raid1 path, but I
guess stranger things have happened.

--
Dan
