Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbXFSOAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbXFSOAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXFSOAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:00:36 -0400
Received: from mail-relay-02.mailcluster.net ([85.249.135.243]:50762 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbXFSOAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:00:35 -0400
Message-ID: <4677E176.5090102@vlnb.net>
Date: Tue, 19 Jun 2007 18:00:22 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
Cc: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net> <46779DB1.7060807@draigBrady.com> <20070619120457.GD14108@think.oraclecorp.com>
In-Reply-To: <20070619120457.GD14108@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Tue, Jun 19, 2007 at 10:11:13AM +0100, Pádraig Brady wrote:
> 
>>Vladislav Bolkhovitin wrote:
>>
>>>I would also suggest one more feature: support for block level
>>>de-duplication. I mean:
>>>
>>>1. Ability for Btrfs to have blocks in several files to point to the
>>>same block on disk
>>>
>>>2. Support for new syscall or IOCTL to de-duplicate as a single
>>>transaction two or more blocks on disk, i.e. link them to one of them
>>>and free others
>>>
>>>3. De-de-duplicate blocks on disk, i.e. copy them on write
>>>
>>>I suppose that de-duplication itself would be done by some user space
>>>process that would scan files, determine blocks with the same data and
>>>then de-duplicate them by using syscall or IOCTL (2).
>>>
>>>That would be very usable feature, which in most cases would allow to
>>>shrink occupied disk space on 50-90%.
>>
>>Have you references for this number?
>>In my experience one gets a lot of benefit from
>>the much simpler process of "de-duplication" of files.
> 
> 
> Yes, I would expect simple hard links to be a better solution for this,
> but the feature request is not that out of line. 

 From effort POV hard links could be a better solution, but from 
effectiveness POV I can't agree with you.

> I actually had plans
> on implementing auto duplicate block reuse earlier in btrfs.
> 
> Snapshots already share duplicate blocks between files, and so all of
> the reference counting needed to implement this already exists.
> Snapshots are writable, and data mods are copy on write, and in general
> things work.
> 
> But, to help fsck, the extent allocation tree has a back pointer to the
> inode that owns an extent.  If you're doing snapshots, all of the owners
> of the extent have the same inode number.   If you're sharing duplicate
> blocks, the owners can have any inode number, and fsck becomes much more
> complex.
> 
> In general, when I have to decide between fsck and a feature, I'm going
> to pick fsck.  The features are much more fun, but fsck is one of the
> main motivations for doing this work.

I see. Thanks for explaining your position.

Vlad
