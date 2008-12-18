Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753702AbYLRUGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYLRUGg (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYLRUGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:06:21 -0500
Received: from ns2.suse.de ([195.135.220.15]:44696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbYLRUGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:06:20 -0500
From: "NeilBrown" <neilb@suse.de>
To: "Dylan Taft" <d13f00l@gmail.com>
Date: Fri, 19 Dec 2008 07:06:11 +1100 (EST)
Message-ID: <44f470466dcf22c47f6700502caf9cbd.squirrel@neil.brown.name>
In-Reply-To: <47ed01bd0812180508t89d1aecr13d2b9e8402ed885@mail.gmail.com>
References: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
    <20081218065603.GA21265@mail.local.tull.net>
    <47ed01bd0812180508t89d1aecr13d2b9e8402ed885@mail.gmail.com>
Subject: Re: MDADM Software Raid Woes
Cc: "Nick Andrew" <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, December 19, 2008 12:08 am, Dylan Taft wrote:
> I may give that a shot.
>
> But it also looks like my major numbers are wrong on the actual device
> nodes?
> brw-r-----  1 root disk   9, 0 Dec 17 19:13 0
> brw-r-----  1 root disk 259, 0 Dec 17 19:13 1
> brw-r-----  1 root disk 259, 1 Dec 17 19:13 2
> brw-r-----  1 root disk 259, 2 Dec 17 19:13 3
>
> Shouldn't this be 9,something, not 259?
>
> If I change the partition type from fd to something else, and don't
> allow the kernel to auto assemble, then assemble manually via mdadm,
> things work right.
> Any idea what could cause thee major numbers to be wrong?

Almost certainly some udev configuration going wrong.
What distro are you running?
Is there are file in /lib/udev/rules.d or /etc/udev/rules.d with 'md'
in the name?  What is in that file?

Prior to 2.6.28, normal md devices (major number 9) could not be
partitioned. You needed to use "mdp" devices (major number close to 254).
To get autodetect to create these use the kernel parameter
"raid=partitionable".

In 2.6.28, partitions don't have to have the same major number as the
base device.
In you case,
  md0 is 9,0
  md1 is 9,1

  md1p1 is 259,0
  md1p2 is 259.1
  md1p3 is 259,2

as you can see, the device nodes have been created with the wrong
name.  In each case the name used is md followed by the last digit
of what should have been used.  udev is the only thing that could have
done that.

Hence my questions about your distro and udev configuration.

NeilBrown

