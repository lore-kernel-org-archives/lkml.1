Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZFVSJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZFVSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbZFVSJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:09:45 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:58945 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbZFVSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fA+QnN2kUN6XjY6GqglVpBuup3aPCwmCgL8SgScJY+YXw+cG3ubGPCMYzKVG/vsE+2
         0OD2+uxbhGk4Aa07zjxQY9Oa8TCHNGhlCLEJyt88eLhI7R9MTZGVTgHDnQhGwQjwj0Dh
         MprHaZcJDwWrfdaAJv1qVVkKmEtnfUmT5TtAw=
Message-ID: <4A3FC7F1.5050108@gmail.com>
Date: Mon, 22 Jun 2009 20:05:37 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
References: <4A33A7EC.6070008@gmail.com> <200906212222.25434.arnd@arndb.de> <2ea1731b0906212323h6ed8621dg22e1bc8638c26e2c@mail.gmail.com> <200906221317.04166.arnd@arndb.de>
In-Reply-To: <200906221317.04166.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 22 June 2009, Marco Stornelli wrote:
>>> It's still a problem. You might be creating a file system image
>>> for an embedded board with a different endianess.
>> It's not possible to create an "image" with pramfs, it's like tmpfs.
> 
> But the data is persistant, you even support using it as a root file
> system, so the data has to have a way to get there. Even if you
> don't do it right now, I don't see any fundamental limitation that
> prevents you from creating an image on one machine and dumping it
> into the nvram of another machine as part of manufacturing or testing.
> 

Sorry, I meant it's not *currently* possible. At the moment the only way
to use it as rootfs it's to copy all the data in an already mounted
(empty) ram partition and reboot. However it's not my first item on my
todo list because I think that it's possible to use it as rootfs but it
isn't the standard use for this fs.


>>> Or even on the same machine, you could be looking at the file system contents
>>> with a 32 bit process running on a 64 bit kernel.
>> Yes, indeed the most important thing is to be sure that a 64bit kernel
>> works well. I'll try to test it in this environment. If there are
>> "64bit guys" to help me to test it, it'd be great.
> 
> This particular problem (__kernel_off_t on 64-bit machines) can be avoided
> by just switching to __kernel_loff_t, which is 64 bit long on all machines,
> while __kernel_off_t is always the register length (32 or 64 bits).
> 
> 	Arnd <><
> 

Yep, it can be a good idea, thanks for the tip.

Marco
