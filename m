Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXFKUIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXFKUIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbXFKUIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:08:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbXFKUIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:08:46 -0400
Message-ID: <466DAAD9.2030207@sandeen.net>
Date: Mon, 11 Jun 2007 15:04:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Karl Pickett <karl.pickett@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG when using corrupted ext3 fs
References: <f9be06770706080751y4bbb60d0q3a2286d8e2b576f6@mail.gmail.com> <f9be06770706080753m41959da2m2034e428854c1c0b@mail.gmail.com>
In-Reply-To: <f9be06770706080753m41959da2m2034e428854c1c0b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Pickett wrote:
> I had to hard shutdown a fc6 machine due to vmware and nvidia doing
> ridiculous things to my screen resolution and locking up.  ugh.
> Anyway, upon reboot it recovers the journal and mounts / rw fine.
> Then rc.sysinit tries to delete various things from /tmp (.ICE-unix,
> .font stuff, etc), kernel shows a BUG, and boot stops.  Booting from a
> fc7 live cd and trying to mount /dev/sda2 rw and delete /tmp/* also
> causes a BUG.  This dump is from fc7:
> 

...

The corrupted orphan inode list bug I fixed,

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2988a7740dc0dd9a0cb56576e8fe1d777dff0db3

is in that fc7 kernel, so that's probably not it (though your fc6 kernel
probably didn't have that fix)  (it's related to link & unlink racing)

Perhaps this could be related to Vasily's issue w/ bad_inodes not
getting removed from the list ?

[RFC PATCH ext3/ext4] orphan list corruption due bad inode
http://lkml.org/lkml/2007/6/4/7

I haven't looked at all the ways we could get bad inodes on the orphan
inode list, and not properly removed...

-Eric
