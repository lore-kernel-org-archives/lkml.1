Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab0BPBYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 20:24:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55331 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932362Ab0BPBYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 20:24:47 -0500
Message-ID: <4B79F3CE.5030907@zytor.com>
Date: Mon, 15 Feb 2010 17:24:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Michael Evans <mjevans1983@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>	<4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>	<4B77044B.1020609@zytor.com> <20100216112708.4a863f86@notabene.brown>
In-Reply-To: <20100216112708.4a863f86@notabene.brown>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 04:27 PM, Neil Brown wrote:
> 
> When mdadm defaults to 1.0 for a RAID1 it prints a warning to the effect that
> the array might not be suitable to store '/boot', and requests confirmation.
> 
> So I assume that the people who are having this problem either do not read,
> or are using some partitioning tool that runs mdadm under the hood using
> "--run" to avoid the need for confirmation.  It would be nice to confirm if
> that was the case, and find out what tool is being used.

My guess is that they are using the latter.  However, some of it is
probably also a matter of not planning ahead, or not understanding the
error message.  I'll forward one email privately (don't want to forward
a private email to a list.)

> If an array is not being used for /boot (or /) then I still think that 1.1 is
> the better choice as it removes the possibility for confusion over partition
> tables.
> 
> I guess I could try defaulting to 1.2 in a partition, and 1.1 on a
> whole-device.  That might be a suitable compromise.

In some ways, 1.1 is even more toxic on a whole-device, since that means
that it is physically impossible to boot off of it -- the hardware will
only ever read the first sector (MBR).

> How do people cope with XFS??

There are three options:

a) either don't boot from it (separate /boot);
b) use a bootloader which installs in the MBR and
hopefully-unpartitioned disk areas (e.g. Grub);
c) use a nonstandard custom MBR.

Neither (b) or (c), of course, allow for chainloading from another OS
install and thus are bad for interoperability.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

