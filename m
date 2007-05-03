Return-Path: <linux-kernel-owner+w=401wt.eu-S1767520AbXECQyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767520AbXECQyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767515AbXECQyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:54:41 -0400
Received: from smtpout.mac.com ([17.250.248.175]:57616 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767520AbXECQyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:54:40 -0400
In-Reply-To: <20070503151047.GB3866@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org> <1177711666.4737.176.camel@nigel.suspend2.net> <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com> <20070503151047.GB3866@ucw.cz>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E92E80B1-2D3F-4942-A17B-AED903F535C6@mac.com>
Cc: nigel@nigel.suspend2.net, Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Back to the future.
Date: Thu, 3 May 2007 12:53:48 -0400
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 03, 2007, at 11:10:47, Pavel Machek wrote:
> How mature is freezing filesystems -- will it work on at least  
> ext2/3 and vfat?

I'm pretty sure it works on ext2/3 and xfs and possibly others, I  
don't know either way about VFAT though.  Essentially the "freeze"  
part involves telling the filesystem to sync all data, flush the  
journal, and mark the filesystem clean.  The intent under dm/LVM was  
to allow you to make snapshots without having to fsck the just- 
created snapshot before you mounted it.

> What happens if you try to boot and filesystems are frozen from  
> previous run?

If you're just doing a fresh boot then the filesystem is already  
clean due to the dm freeze and so it mounts up normally.  All you  
need to do then is have a little startup script which purges the  
saved image before you fsck or remount things read-write since either  
case means the image is no longer safe to resume.

If the kernel is later modified to purge all filesystem data (dcache/ 
pagecache) during snapshot and effectively remount and reopen all the  
files by path during restore then you could remove that requirement.   
You'd just need to make sure that the restore-from-disk scripts did  
an fsck or journal-restore before reloading the old kernel data.

Cheers,
Kyle Moffett
