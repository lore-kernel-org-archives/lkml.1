Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZIYUso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZIYUso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZIYUso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:48:44 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:58199 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZIYUsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qElPQ9SRC4r1jop32tXI+2efUZeNXhmIuZ/D7gXBZj01O9PDxQwTJi4vHHl3BnpqHe
         jmE9soHE9M08rIsqoCx7sHP1G79t+wbs49o/GxN0B2GgaGwdof/0uxwo3f+uFNth/jI3
         S37yk2Ru40e6W6w3SmcXdXvDlmcaNGGqoKWTk=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0909251324h115c5c47wb2d50cc982ba17dd@mail.gmail.com>
References: <1252950549-9838-1-git-send-email-vapier@gentoo.org> 
	<1253223426-5938-1-git-send-email-vapier@gentoo.org> <20090924163240.d03127e3.akpm@linux-foundation.org> 
	<8bd0f97a0909251324h115c5c47wb2d50cc982ba17dd@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 25 Sep 2009 16:48:27 -0400
Message-ID: <8bd0f97a0909251348k9e5240av6ebd49d2e99c04a1@mail.gmail.com>
Subject: Re: [PATCH v2] fbdev: bfin-lq035q1-fb: new Blackfin Landscape LCD 
	EZ-Extender driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       michael.hennerich@analog.com, cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 16:24, Mike Frysinger wrote:
> On Thu, Sep 24, 2009 at 19:32, Andrew Morton wrote:
>> On Thu, 17 Sep 2009 17:37:06 -0400 Mike Frysinger wrote:
>>> +static int lq035q1_control(unsigned char reg, unsigned short value)
>>> +{
>>> +     int ret;
>>> +     u8 regs[3] = {LQ035_INDEX, 0, 0};
>>> +     u8 dat[3] = {LQ035_DATA, 0, 0};
>>> +
>>> +     if (spi_control.spidev) {
>>> +             regs[2] = reg;
>>> +             dat[1] = value >> 8;
>>> +             dat[2] = value & 0xFF;
>>> +
>>> +             ret = spi_write(spi_control.spidev, regs, ARRAY_SIZE(regs));
>>> +             ret |= spi_write(spi_control.spidev, dat, ARRAY_SIZE(dat));
>>> +     } else
>>> +             return -ENODEV;
>>> +
>>> +     return ret;
>>> +}
>>
>> I am suspecting that this function (and the similar ones below) rely
>> upon state within the hardware and will hence misbehave if two
>> instances are run concurrently.
>>
>> Is that correct>  If so, is there locking to prevent this from occurring?
>
> if by "instances" you mean "users" as in "multiple programs
> reading/writing the framebuffer concurrently", then probably.  rather
> than handle the locking ourselves, it can be pushed to the SPI bus by
> having the regs/dat be transfers in a single message.

hmm there shouldnt be any locking problems here actually.  the spi
access is only to initialize/shutdown, and there is a dedicated CS for
each device.  so i dont think anything here really needs changing
(other than to allocate the spi_control global variable dynamically in
the probe).
-mike
