Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbYHUOaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbYHUOaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYHUOaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:30:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:25959 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbYHUOaF (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oiHffXM66l5pcIBA+eNcwzFI4hKio3aMutqGYYTK6irWTnxGBRW0OZoJyEKM0n4Ws3
         huZ61ptjU3s8A175zguZWkSxDtRKdcL6iFoCd27zn9obIr5NLhBwl7EVLparu6RZi5vz
         NUbAqzJ7Xj0OMt8kgLQEALUF9kU7RNXObJajk=
Message-ID: <6934efce0808210730y77db925cg263c957abb056fea@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:30:03 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       nickpiggin@yahoo.com.au
In-Reply-To: <48AD42AE.4030107@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <48AD42AE.4030107@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I like the general approach of it. It's much more flexible than the ext2
> extension I've done, and the possibility to select XIP vs. compression per
> page is really really neat. I can imagine that people will prefer this over
> the ext2 implementation on s390. It is unclear to me how the "secondary
> block device" thing is supposed to work. Could you elaborate a bit on that?

First off we don't yet support direct_access(), but I am planning on that soon.

Sure.  For a system that has say a NOR Flash and a NAND or a embedded
MMC, one can split a filesystem image such that only the XIP parts of
the image are on the NOR while the compressed bits are on the NAND /
eMMC.  The NOR part is accessed as directly addressable memory, while
the NAND would use mtd->read() and the eMMC would use block device
access API's.  In this case I would call this NAND or eMMC the
"secondary device" because the primary device is the NOR.

Assuming my NOR was at /dev//mtd2 and my NAND at /dev/mtd5.  I would
call the following to mount such a system:

mount -t axfs -o second_dev=/dev/mtd5 /dev/mtd2 /mnt/axfs
