Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYKTKhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYKTKhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 05:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYKTKgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 05:36:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:50599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbYKTKgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 05:36:50 -0500
From: "NeilBrown" <neilb@suse.de>
To: =?iso-8859-1?Q?Pawe=B3_Sikora?= <pluto@agmk.net>
Date: Thu, 20 Nov 2008 21:36:43 +1100 (EST)
Message-ID: <03939301a556d2819d6af347493d2c64.squirrel@neil.brown.name>
In-Reply-To: <kiMF2GVq.1227171795.6518750.pluto@agmk.net>
References: <kiMF2GVq.1227171795.6518750.pluto@agmk.net>
Subject: Re: [2.6.27.6] jfs on raid1 => attempt to access beyond end of 
     device.
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, November 20, 2008 8:03 pm, Pawe³ Sikora wrote:
> hi,
>
> few hours ago i've set up jfs filesystems on raid1 and raid0.
> during restoring backup i've got an errors in dmesg.
> the testcase on my system is easy and 100% reproducible:
> just do the following command on jfs/raid1 device:
....

> /dev/sda2   *         748        2206    11719417+  fd  Linux raid
                                           ^^^^^^^^^
size of sda2 is Kilobytes - 23438835 sectors.


>
> md0 : active raid1 sda2[0] sdb2[1]
>       11719296 blocks [2/2] [UU]
        ^^^^^^^^

size of md0 in kilobytes - 23438592 sectors.


> [ 5583.796222] attempt to access beyond end of device
> [ 5583.796227] md0: rw=1, want=23438832, limit=23438592
Largest 'want' value.

'want' is just less than size of sda2
'limit' is exactly size of md0 (no surprise there).

> any ideas what's wrong?

I suspect you created the filesystem on /dev/sda2, not realising
that when you created a raid1 from sda2 and sdb2 it would be slightly
smaller than sda2 (as md used up to 120K for metadata storage).

NeilBrown

(P.S. I love it when people provide all the details thus making it
 easier for me to spot what is happening - thanks!)

