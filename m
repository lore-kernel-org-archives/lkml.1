Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYJBXp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYJBXp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYJBXpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:45:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:17400 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYJBXpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GRsFwATvMfioWq1nim4BESsy9nwsxsGc2d3kRQPf90ejnKYF7PofPTXj6EAs7AeAYr
         BAV9AWGOsgK69ZxRyd8G6KsY2jOZdHDkjau3bjp6QTNAHbwbPjt/UpTAtts9IZdkvKdU
         rrbVKxj+mWDmnon4LMgB5vQIxmhzwvQ3l05DI=
Message-ID: <86802c440810021645x4076e3feqba2c5ec3e3ea3d00@mail.gmail.com>
Date: Thu, 2 Oct 2008 16:45:49 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081003012036.28c00fd7@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	 <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
	 <20081003003237.04469201@werewolf.home>
	 <86802c440810021539y6cdff33dh9df3e04eba85a9df@mail.gmail.com>
	 <20081003012036.28c00fd7@werewolf.home>
X-Google-Sender-Auth: 5ac76716dc43d3b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 4:20 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> On Thu, 2 Oct 2008 15:39:34 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:
>
> Oops, sorry, this is without cleanup. This is a distro kernel and is built
> but not enable by deafult. As it is rc7, I will use 'enble_mtrr_cleanup' ;):
>
> cicely:~# cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
> reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1
>
> I have lost 2Gb ?

that is memhole

>
> cicely:~# free
>             total       used       free     shared    buffers     cached
> Mem:       3755568     182348    3573220          0      14024      72716
> -/+ buffers/cache:      95608    3659960
>
> I can't easily try your patch, this is a distro kernel.
> I will get the src.rpm...

just pull tip/master, and use your config from /boot/config....

>
> Ahhhhh....
>
> This is a dual opteron board. dmidecode says:
>
> Handle 0x0026, DMI type 16, 15 bytes
> Physical Memory Array
>    Location: System Board Or Motherboard
>    Use: System Memory
>    Error Correction Type: Single-bit ECC
>    Maximum Capacity: 8 GB
>    Error Information Handle: Not Provided
>    Number Of Devices: 8
>
> So it maps one Opteron memory in first 4Gb and the other on the second 4Gb.
> So I should have 2Gb@0 and 2Gb@4Gb.
> What I don't know is why the bios eats up 256Mb.

check if you enable memhole remapping in BIOS.

YH
