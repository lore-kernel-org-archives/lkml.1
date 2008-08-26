Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYHZTBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYHZTBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758921AbYHZTAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:00:01 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59991 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206AbYHZS76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aJntt4+cjKxWE2tnEzuev/6ZpWR+HRtgznbC6EL0Cacg3V9sR9hL659FeseJVoVAuT
         oNWSr06FGuyjiHFuHShycLgym4xjWUvvo6x2RCgKmfkahu2gCsl4pwMiXEUP+miOKeak
         E5A8LGbbpGp0hqhib/rLPm4Y7GAJfJvbt8xKs=
Message-ID: <3efb10970808261159p2c79303er7f42983d22eb4891@mail.gmail.com>
Date: Tue, 26 Aug 2008 20:59:57 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Wolfgang Denk" <wd@denx.de>
Subject: Re: [U-Boot] [patch 2/2] Add support for building the new U-boot uImage format (FIT-format)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       u-boot@lists.denx.de, sam@ravnborg.org, "Stefan Roese" <sr@denx.de>
In-Reply-To: <20080825211839.CF83524899@gemini.denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080825191427.728251800@bohmer.net>
	 <48b30a00.1701d00a.4ee8.ffffa5f7@mx.google.com>
	 <20080825211839.CF83524899@gemini.denx.de>
X-Google-Sender-Auth: 6d33ad02c14890a8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfgang,

>> If an older mkimage is detected, or if there is no dtc (Device Tree Compiler)
> Why should there ever be no dtc? It is part of the Linux kernel source
> tree, see arch/powerpc/boot/dtc-src

Okay, I see it is there in 2.6.27-rc, but the version there is pre
historical, and definitely in the wrong location, because it is not
PowerPC only anymore. It does not support the incbin directive, so it
cannot be used to build a uImage.
We need at least version 1.2.0 of DTC.

>> then automagically the legacy format is created.
>> There is also a possibility to force the legacy format by means of a Kconfig
>> option.
>
> As before, I think this should not be implemented as a  configuration
> option; it should be selectable as separate make targets without need
> to reconfigure / rebuild the kernel.

I agree if you are talking about the other patch which was about
choosing between compressed image yes/no; related to the current make
targets they should indeed be similar to Image/zImage. I made it
configurable because that saved me some time adapting the
build-tooling for the target-filesystem. (and thought it could be
handy for others too)

But, for this patch I disagree, I do not think it should be separate
make targets, because it is choosing between a legacy and a new image
file format. Legacy means that it is old and should go away some time.
When it comes to functionality it will behave the same like the old
uImage (on no-powerpc architectures at least), so creating a new
filename as make-target would imply all tools that depend on the
target name uImage should be adapted to a new name, when there is no
new functionality, resulting in a very long time before the new format
because 'the standard'. Not to speak about documentation issues.
IMO it is a replacement, not just an additional format.

>> Note: This patch only adapts this for ARM, AVR32, Blackfin and sh architectures.
>>       It does not adapt the PowerPC tree, because PowerPC does not use the
>>       script at scripts/mkuboot.sh
>
> Hm... Power support would be especially interesting, of course :-)

I knew that, that is why I added this note... But I do not have
PowerPC systems (except my PS3, or Qemu) so it is not easy to test any
modifications in that area, and there is a risk of breaking things.
Besides, if I look at how I believe things are done for PowerPC, it
can easily be added to the mkuboot.sh script, once it knows about the
FIT format, and the proper tools are available.
I may look at that later, when I have more free (hobby) time.

Kind Regards,

Remy
