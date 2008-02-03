Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYBCWGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYBCWGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYBCWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:06:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYBCWGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:06:35 -0500
Message-ID: <47A63AD3.6080501@redhat.com>
Date: Sun, 03 Feb 2008 23:06:11 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: linux-kernel@vger.kernel.org, dm-crypt@saout.de
Subject: Re: data corruption with dmcrypt/LUKS
References: <1202050237.3200.33.camel@fermat.scientia.net>
In-Reply-To: <1202050237.3200.33.camel@fermat.scientia.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Anton Mitterer wrote:
> <when I diff -q -r /mnt/unencrypted /mnt/encrypted/ here, everything is
> ok but this is just, because those files are still cached in RAM>
> <unmount + close mapping + reboot>
> <create mappings and mount everything again>
> 
> Here's the first problem:
> 1) When I now diff the two versions again (the unencrypted and the one
> from the encrypted partition) I get differences...
> I'm quite sure that this is not due to damaged RAM or harddisk (checked
> several times with memtest and badblocks) and the corruption is always
> the same, although not fully reproducibly.
> The filesystem tree itself seems to be the same on both discs (but I'm
> not sure if the permissions and owners are copied correctly), but there
> are differences in some (though not all) files.
> The difference is always the same, that for one or more bytes of the
> affected files, the hexcode is reduced by 0x10
> That is:
> If the file contains a byte "T" (0x74) on the unencrypted partition it
> will have a "D" (0x64) on the encrypted.

Hi,
Are you sure, that your USB-stick is not faulty ?
Could you reproduce it with different piece of hw ?
(Several strange reports for dm-crypt over USB were identified to be 
USB hw faults.)

> 2) The second bug happens only rarely and leads to a panic.
> Unfortunately it's difficult to reproduce, but it always happened when I
> mkfs.ext3 on the /dev/mapper/sda2.
> There's a stack-trace printed which clearly involves some dmcrypt
> lines...

But no stack trace attached here... please attach it.

It can be known bug which was fixed in stable version some time ago
see http://lkml.org/lkml/2007/7/20/211

> btw: are there any other currently known bugs in dmcrypt? Or is it
> considered as "production stable"?

No known bugs causing data corruption, no such reports so far
for stable kernel.

Milan
--
mbroz@redhat.com

