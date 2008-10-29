Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYJ2Uh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYJ2Uh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYJ2UhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:37:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42716 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbYJ2UhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:37:12 -0400
Message-ID: <4908C951.2000309@redhat.com>
Date: Wed, 29 Oct 2008 15:36:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Arthur Jones <ajones@riverbed.com>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, sct@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: ext3: slow symlink corruption on umount...
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com>
In-Reply-To: <20081029195403.GA8333@ajones-laptop.nbttech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arthur Jones wrote:
> This one's turning out to be a slippery fish.
> I have found that the corruption appears to
> be due to ->writepage() not getting called at all
> for any of the long symlinks...
> 
> Ring any bells anyone?  Any ideas where to look
> or what to test?  This is my first foray into
> ext3 and I could definitely use some expert advice...
> 
> Arthur


Sorry for the silence, this is a nice bug you've found :)

I can reproduce this at least, with this script:

#!/bin/bash

umount /mnt/test2
mount /dev/sdb4 /mnt/test2
rm -f /mnt/test2/*
dd if=/dev/zero of=/mnt/test2/bigfile bs=1M count=512
touch
/mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
ln -s
/mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
/mnt/test2/link
umount /mnt/test2
mount /dev/sdb4 /mnt/test2
ls /mnt/test2/
umount /mnt/test2

I'll look into it ...

-Eric
