Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYJWBGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYJWBGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYJWBGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:06:24 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:55169 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYJWBGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iYeGCA+s2vbI6BDG4tQvRf1j0XZFZIbBcfhJP0MDwkytE4wLHlhBK9UdXsEo7PxFi7
         zYbkmLqpT2CpUIFXTxBa2tP8Kx6YrCZ5NB299ZitLABtG7pBRtAnHBXXZfp1hW54+3J+
         OdShnysEncxJxvbPlV40TRAC6RLjYweI6wEh4=
Message-ID: <386072610810221806v52f435dbya1d3b8e181b92559@mail.gmail.com>
Date: Thu, 23 Oct 2008 09:06:21 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [BUG] re-modprobe a nand controller driver module will cause system crash.
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <8bd0f97a0810220759h837794eo76c4413d6072dcf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610810160356p3807f538la5087debe0c76866@mail.gmail.com>
	 <386072610810212024l52cd86cen79061d7111c421ba@mail.gmail.com>
	 <8bd0f97a0810220759h837794eo76c4413d6072dcf9@mail.gmail.com>
X-Google-Sender-Auth: f43f2de1b8da5247
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 10:59 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Tue, Oct 21, 2008 at 23:24, Bryan Wu wrote:
>> Did anyone meet this issue before?
>
> actually i think we can see the same issue with the m25p80 driver ?
> if i build it as a module and load/unload it, it crashes with same
> name errors ...
>

Right, this is a common bug for mtd core.

-Bryan

> root:/> rmmod m25p80
> root:/> modprobe m25p80
> m25p80 spi0.2: w25x10 (128 Kbytes)
> Creating 3 MTD partitions on "m25p80":
> 0x00000000-0x00040000 : "bootloader(spi)"
> mtd: partition "bootloader(spi)" extends beyond the end of device
> "m25p80" -- size truncated to 0x20000
> kobject_add_internal failed for 31:0 with -EEXIST, don't try to
> register things with the same name in the same directory.
> <crash message>
> -mike
>
