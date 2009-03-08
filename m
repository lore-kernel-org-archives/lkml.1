Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbZCHN3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbZCHN3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 09:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZCHN3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 09:29:43 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:49459 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbZCHN3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 09:29:42 -0400
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-10.arcor-online.net F3DCA28F1AD
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Question regarding direntry read error in fat filesystem when a  	device is removed
To: YS Kim <historic59@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sun, 08 Mar 2009 14:29:37 +0100
References: <cbSsR-2ry-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LgJ4U-00021e-1p@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YS Kim <historic59@gmail.com> wrote:

> I have a question about too many error messages from FAT when
> unexpected device removal occurs.
> I got the following error messages when I unplugged a USB
> drive(formatted as FAT) during direntry reading.
> 
> sd 0:0:0:0: rejecting I/O to device being removed
> FAT: Directory bread(block 1478192) failed
> sd 0:0:0:0: rejecting I/O to device being removed
> FAT: Directory bread(block 1478193) failed
> sd 0:0:0:0: rejecting I/O to device being removed
> FAT: Directory bread(block 1478194) failed
> sd 0:0:0:0: rejecting I/O to device being removed
> FAT: Directory bread(block 1478195) failed
> ...
> 
> From the code of fat__get_entry in dir.c, I found that it continues to
> read the next device block
> even if the block reading has been failed. Because of this continuous
> read, a lot of error messages
> come up if the device itself is removed during reading fairly many
> files, and it causes the malfunction
> of my embedded system.
[...]
> Thus, if I modify the code to just return error when fat__get_entry
> fails to read blocks, could it be
> cause any side effects? Except the purpose of backup/recovery, is
> there any other reason for
> the continuous block read?

I guess aborting the directory read would work as expected, but what about
suppressing the messages if you're not sure?

