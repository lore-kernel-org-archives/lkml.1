Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXBEV2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXBEV2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933474AbXBEV2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:28:39 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:41709 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464AbXBEV2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:28:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M1DlrYZkVfAQCl4se1n/8Ir6irB4QISnX4xcIl0eyEBcC1NtSHX2DDBA2fIUFNjWVyXYR6gdu452JC4UHiCalpjshPqL8OrvHgNKfX4/JhSZ1vqnBWSE2Dl7meaILmlIZRPq86tK30iiOxfZxwrxCljZQ/V/Lqc/MYdSqCpqTKo=
Message-ID: <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
Date: Mon, 5 Feb 2007 22:28:36 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Luca Tettamanti" <kronos@people.it>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: linux-fbdev-devel@lists.sourceforge.net, "Andrew Morton" <akpm@osdl.org>,
       "Dave Airlie" <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070205201824.GA13431@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070128160831.fb51347f.akpm@osdl.org>
	 <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com>
	 <20070205201824.GA13431@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Luca Tettamanti <kronos@people.it> wrote:
> get-edid uses the BIOS, while the other two talk directly over the I2C
> bus.
>
> Try loading i2c-dev (I2C_CHARDEV); With i2cdump[1] you can read the EDID
> block, which resides at address 0x50:
>
> i2cdump N 0x50 (where N is the bus number)
>
> If you are unshure about bus number try with all the available
> /dev/i2c-* devices (you may want to unload HW monitor drivers first, so
> you don't poke at random stuff).

No luck. i2c-dev and dependencies are loaded
""" lsmod | grep i2c reports """
i2c_i801                7404  0
i2c_isa                 5152  0
i2c_piix4               8140  0
i2c_algo_pcf            6180  0
i2c_algo_pca            5380  0
i2c_algo_bit            8424  0
i2c_dev                 8548  0
i2c_core               19680  7
i2c_i801,i2c_isa,i2c_piix4,i2c_algo_pcf,i2c_algo_pca,i2c_algo_bit,i2c_dev
""""

There is no such thing as /dev/i2c* UNLESS I load nvidiafb. When I
load that, I get three busses (i2c-0, -1, and -2), but i2cdump N 0x50
gives me a nice tableau of X's all around, for all values of N. This
is using kernel 2.6.18-3 stock Debian kernel. I'll keep trying with
some variations, to see if I can get more sensible information.

-- 
Giuseppe "Oblomov" Bilotta
