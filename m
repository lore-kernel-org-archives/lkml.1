Return-Path: <linux-kernel-owner+w=401wt.eu-S935765AbXGSApG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935765AbXGSApG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbXGSAo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:44:56 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:22012 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761332AbXGSAoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Q1rWiZXQSsk9v7iUGSrHqprK3dGM0ZRT2VCusVpDqJedDgg7sr4UHEY3PWVxHHtlIBZkfJACWP8XEc6LUUgrevOHAPbhAHmwRSpJd9Lg8IxwlfOQPI3mNM6r1xHwnNUFrgpsDkMHE6sbXVerIpBf4VPhC8EjYredNfuSRTTL+nw=
Message-ID: <3ae72650707181744l47d6cbc6m75b7d9292959a245@mail.gmail.com>
Date: Thu, 19 Jul 2007 02:44:54 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
Cc: "Greg KH" <gregkh@suse.de>, "Tejun Heo" <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070718220652.15ad2c4b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070715124232.4e371bf9@hyperion.delvare>
	 <20070717034844.GB11602@suse.de>
	 <20070717131255.71b7e72e@hyperion.delvare>
	 <20070717183652.GG9702@suse.de>
	 <20070717230530.64d9a896@hyperion.delvare>
	 <20070718033828.GA8582@suse.de>
	 <20070718220652.15ad2c4b@hyperion.delvare>
X-Google-Sender-Auth: 9b085115d797186d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Jean Delvare <khali@linux-fr.org> wrote:
> On Tue, 17 Jul 2007 20:38:28 -0700, Greg KH wrote:
> > On Tue, Jul 17, 2007 at 11:05:30PM +0200, Jean Delvare wrote:
> > > This breaks libsensors. libsensors uses libsysfs, and libsysfs is not
> > > very smart in that it will initialize successfully even if sysfs is not
> > > mounted.
> >
> > libsysfs isn't smart at all, and isn't even supported anymore.  I'd
> > really suggest droping it entirely, it isn't worth it.
>
> Agreed, except that I do not have the time for this right now. I want
> to get lm-sensors-3.0.0 ready for a release candidate first. What
> really matters for this is to get the API ready. Implementation details
> will come later.
>
> > > So I added tests after the initialization, to make sure that
> > > sysfs is really there. These tests are:
> > > * The mount point exists.
> > > * The mount point is really mounted.
> >
> > Do you know of a 2.6 based distro that does not mount sysfs at /sys?  We
> > took that check out a long time ago in udev and no one has complained :)
>
> I don't know of any 2.6-based distro not mounting sysfs at /sys, but I
> know of 2.4-based distros not mounting sysfs at all ;) libsensors
> supports both 2.4 and 2.6 kernels, so being able to tell whether sysfs
> is mounted or not, matters.
>
> > > The code looks like:
> > >
> > >        if (sysfs_get_mnt_path(sensors_sysfs_mount, NAME_MAX)
> > >          || stat(sensors_sysfs_mount, &statbuf) < 0
> > >          || statbuf.st_nlink <= 2)      /* Empty directory */
> > >                 return 0;           /* Failure */
> > >
> > > This works OK with 2.6.22.1, but the last test fails with the current
> > > git kernel even when sysfs is mounted.
> >
> > Yeah, but is checking the number of hard links in the directory a safe
> > way to always verify that it isn't empty?
>
> I think so, yes. To the best of my knowledge, it has worked on all
> Unix-like systems for decades. There are other ways, but this is by far
> the less expensive.

Well, just check if /sys/devices/ exists, that should be cheap enough. :)

Kay
