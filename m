Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYLSAEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYLSAEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYLSADw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:03:52 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:62719 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYLSADu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E/zYhTjx0CyKFVIHoiCF7yD9CXJCFotbABPMXRxSGcq1r1y9FlQ+KY+yVblcx2RfoD
         G3uoBMDCqhGxKLwAoOVxKjoqG9+3DIzbnelHBaSR1qxPy0ghnSp4YtRQKCiRKfYYlV2k
         jTXS+2O6K39Gg40dC9l3zAnqy0ipOOjHQ2/3Q=
Message-ID: <47ed01bd0812181603t53a500adgadab6884a7a4a586@mail.gmail.com>
Date: Thu, 18 Dec 2008 19:03:49 -0500
From: "Dylan Taft" <d13f00l@gmail.com>
To: NeilBrown <neilb@suse.de>
Subject: Re: MDADM Software Raid Woes
Cc: "Nick Andrew" <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
In-Reply-To: <44f470466dcf22c47f6700502caf9cbd.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
	 <20081218065603.GA21265@mail.local.tull.net>
	 <47ed01bd0812180508t89d1aecr13d2b9e8402ed885@mail.gmail.com>
	 <44f470466dcf22c47f6700502caf9cbd.squirrel@neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running gentoo, udev 124-r1
I cleared all superblocks on all devices I raided, and undid all the
partition tables, and started from scratch, putting the filesystem on
the raid devices themselves instead of partitioning the raid devices.

Everything is working now, I think it's probably best to keep it
simple, or use LVM
MD is referenced in the udev config files, but everything is working now.

Sorry, I think it was user error. :)
Thanks
Dylan

On Thu, Dec 18, 2008 at 3:06 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, December 19, 2008 12:08 am, Dylan Taft wrote:
>> I may give that a shot.
>>
>> But it also looks like my major numbers are wrong on the actual device
>> nodes?
>> brw-r-----  1 root disk   9, 0 Dec 17 19:13 0
>> brw-r-----  1 root disk 259, 0 Dec 17 19:13 1
>> brw-r-----  1 root disk 259, 1 Dec 17 19:13 2
>> brw-r-----  1 root disk 259, 2 Dec 17 19:13 3
>>
>> Shouldn't this be 9,something, not 259?
>>
>> If I change the partition type from fd to something else, and don't
>> allow the kernel to auto assemble, then assemble manually via mdadm,
>> things work right.
>> Any idea what could cause thee major numbers to be wrong?
>
> Almost certainly some udev configuration going wrong.
> What distro are you running?
> Is there are file in /lib/udev/rules.d or /etc/udev/rules.d with 'md'
> in the name?  What is in that file?
>
> Prior to 2.6.28, normal md devices (major number 9) could not be
> partitioned. You needed to use "mdp" devices (major number close to 254).
> To get autodetect to create these use the kernel parameter
> "raid=partitionable".
>
> In 2.6.28, partitions don't have to have the same major number as the
> base device.
> In you case,
>  md0 is 9,0
>  md1 is 9,1
>
>  md1p1 is 259,0
>  md1p2 is 259.1
>  md1p3 is 259,2
>
> as you can see, the device nodes have been created with the wrong
> name.  In each case the name used is md followed by the last digit
> of what should have been used.  udev is the only thing that could have
> done that.
>
> Hence my questions about your distro and udev configuration.
>
> NeilBrown
>
>
