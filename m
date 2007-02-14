Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXBNJra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXBNJra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbXBNJra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:47:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:9387 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXBNJr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:47:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ake9xwbdGJR+K05FBwDUkp4ZgA5itMYbeWGC4tgmxp/F0r5NgJX+aa3VdLhiJdN4VOawwE3UZe0xibQLNtMjShEpecX1hTC6j6FoMKTuimn3MdaeN+kf2Xww7hmZcKJmU6RiNq7VrVHuuIvafLxLTv5xKO3IASSLqTvAqCMKWZ0=
Message-ID: <5a4c581d0702140147s7931bd63ief299780fa6963a5@mail.gmail.com>
Date: Wed, 14 Feb 2007 10:47:27 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
Cc: torvalds@linux-foundation.org, agruen@suse.de, neilb@suse.de,
       viro@zeniv.linux.org.uk, hch@lst.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070213195116.GA5181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070213195116.GA5181@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Greg KH <greg@kroah.com> wrote:
> Hi,
>
> I've used 'git bisect' to track down a change in the latest git tree
> that is causing dbus-daemon to sit and spin at the time GNOME launches,
> preventing nautlius from ever running.
>
> The bad commit is:
> commit eb3dfb0cb1f4a44e2d0553f89514ce9f2a9fcaf1
> Author: Andreas Gruenbacher <agruen@suse.de>
> Date:   Mon Feb 12 00:51:47 2007 -0800
>
>     [PATCH] Fix d_path for lazy unmounts
>
> With that patch out, GNOME startup works just fine.  I have a strace of
> the dbus process running showing the problem, if anyone thinks that will
> help out any.
>
> I'm running pretty new GNOME and dbus here:
>         dbus 1.0.2
>         gnome 2.16.2
>         hal 0.5.7.1
>         nautilus 2.16.3
>
> Any ideas of things I can test?

Just to add a data point, I see the same problem (startx never
 completes, gnome-vfs-daemon keeps getting forked by dbus
 to no end) on 2.6.20-git9 while -git7 is fine, and my pieces are
 from FC6 updates as of two days ago or so:

[asuardi@sandman ~]$ rpm -q dbus gnome-vfs2 hal nautilus
dbus-1.0.1-9.fc6
gnome-vfs2-2.16.2-2.fc6
hal-0.5.8.1-6.fc6
nautilus-2.16.2-7.fc6

Since the patch breaks userspace in a deadly way, I guess
 it should be reverted until an usable version of the fix can
 be found. And yes, I'm up for testing of course.

--alessandro

 "but I thought that I should let you know
  the things that I don't always show
  might not be worth the time it took"

     (Steve Wynn, 'If My Life Was An Open Book')
