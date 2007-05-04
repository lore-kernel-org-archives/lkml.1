Return-Path: <linux-kernel-owner+w=401wt.eu-S1031349AbXEDHwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031349AbXEDHwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030187AbXEDHwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:52:09 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:55486 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965706AbXEDHwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:52:07 -0400
Message-ID: <463AE623.60501@dgreaves.com>
Date: Fri, 04 May 2007 08:52:03 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org> <1177711666.4737.176.camel@nigel.suspend2.net> <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com> <20070503151047.GB3866@ucw.cz> <E92E80B1-2D3F-4942-A17B-AED903F535C6@mac.com>
In-Reply-To: <E92E80B1-2D3F-4942-A17B-AED903F535C6@mac.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On May 03, 2007, at 11:10:47, Pavel Machek wrote:
>> How mature is freezing filesystems -- will it work on at least ext2/3
>> and vfat?
> 
> I'm pretty sure it works on ext2/3 and xfs and possibly others, I don't
> know either way about VFAT though.  Essentially the "freeze" part
> involves telling the filesystem to sync all data, flush the journal, and
> mark the filesystem clean.  The intent under dm/LVM was to allow you to
> make snapshots without having to fsck the just-created snapshot before
> you mounted it.
> 
>> What happens if you try to boot and filesystems are frozen from
>> previous run?
> 
> If you're just doing a fresh boot then the filesystem is already clean
> due to the dm freeze and so it mounts up normally.  All you need to do
> then is have a little startup script which purges the saved image before
> you fsck or remount things read-write since either case means the image
> is no longer safe to resume.

Wouldn't it be better if freeze wrote a freeze-ID to the fs and returned it?
This would naturally be kept in the image and a UUID mismatch would be
detectable - seems safer and more flexible than 'a script'.

"This isn't the freeze you're looking for, move along"

David
