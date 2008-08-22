Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYHVRIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYHVRIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYHVRIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:08:44 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:2582 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbYHVRIo (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:08:44 -0400
Message-ID: <48AEF2A3.7020905@lougher.demon.co.uk>
Date: Fri, 22 Aug 2008 18:08:51 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?windows-1252?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de> <48AE22F5.3000309@lougher.demon.co.uk> <200808221200.26052.arnd@arndb.de>
In-Reply-To: <200808221200.26052.arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 22 August 2008, Phillip Lougher wrote:
>>> This looks very nice, but could use some comments about how the data is
>>> actually stored on disk. It took me some time to figure out that it actually
>>> allows to do tail merging into compressed blocks, which I was about to suggest
>>> you implement ;-). Cramfs doesn't have them, and I found that they are the
>>> main reason why squashfs compresses better than cramfs, besides the default
>>> block size, which you can change on either one.
>> Squashfs has much larger block sizes than cramfs (last time I looked it 
>> was limited to 4K blocks), and it compresses the metadata which helps to 
>> get better compression.  But tail merging (fragments in Squashfs 
>> terminology) is obviously a major reason why Squashfs gets good compression.
> 
> The *default* block size in cramfs is smaller than in squashfs, but they both
> have user selectable block sizes. I found the impact of compressed metadata
> to be almost zero. 

Squashfs stores significantly more metadata than cramfs.  Remember 
cramfs has no support for filesystems > ~ 16Mbytes, no inode timestamps, 
truncates uid/gids, no hard-links, no nlink counts, no hashed 
directories,  no unique inode numbers.  If Squashfs didn't compress the 
metadata it would be significantly larger than cramfs.

Cheers

Phillip
