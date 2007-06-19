Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbXFSKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbXFSKB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXFSKBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:01:48 -0400
Received: from mail-relay-01.mailcluster.net ([85.249.135.242]:52739 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255AbXFSKBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:01:47 -0400
Message-ID: <4677A972.6030909@vlnb.net>
Date: Tue, 19 Jun 2007 14:01:22 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net> <46779DB1.7060807@draigBrady.com>
In-Reply-To: <46779DB1.7060807@draigBrady.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pádraig Brady wrote:
> Vladislav Bolkhovitin wrote:
> 
>>I would also suggest one more feature: support for block level
>>de-duplication. I mean:
>>
>>1. Ability for Btrfs to have blocks in several files to point to the
>>same block on disk
>>
>>2. Support for new syscall or IOCTL to de-duplicate as a single
>>transaction two or more blocks on disk, i.e. link them to one of them
>>and free others
>>
>>3. De-de-duplicate blocks on disk, i.e. copy them on write
>>
>>I suppose that de-duplication itself would be done by some user space
>>process that would scan files, determine blocks with the same data and
>>then de-duplicate them by using syscall or IOCTL (2).
>>
>>That would be very usable feature, which in most cases would allow to
>>shrink occupied disk space on 50-90%.
> 
> Have you references for this number?

No, I've seen it somewhere and it well confirms with my own observations.

> In my experience one gets a lot of benefit from
> the much simpler process of "de-duplication" of files.

Yes, sure, de-duplication on files level brings its benefits, but on FS 
blocks level it would bring ever more benefits, because there are many 
more or less big files, which are different as a whole, but with a lot 
of the same blocks. Simple example of such files is UNIX-style mail 
boxes on a mail server.

> Note a checksum stored in file metadata,
> that is automatically invalidated on write would
> speed up user space file de duplification,
> and rsync, etc....

Sure, file level deduplication is simpler to implement, but it is 
generally less powerful, than FS block level one. And seems it should 
not be hard to add the above (1)-(3) features in the existing Btrfs 
structure, especially on this stage, when the disk format isn't 
stabilized yet.

> Pádraig.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

