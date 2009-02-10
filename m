Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbZBJU3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbZBJU3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZBJU3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:29:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:21222 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZBJU3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:29:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NyeMpx81PbiAYTXUhcsv0s/KInVEi3hN+kodE3qAq84wrTY3KgghbopaF64sFGPPq2
         CEkKq7343WKZ79gseMfBfTpvhCTMUgbhcCHw2BZfhSaMg8KWvi29uKEtN/E+sGv0OLWl
         GQ5MERZmSsobPRd9JqYKs81MK7C3pnncMAjyE=
MIME-Version: 1.0
In-Reply-To: <49917650.1060208@tudelft.nl>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net> <498E46F2.1020401@gmail.com>
	 <4990BE23.8080301@tremplin-utc.net> <4990DEFD.4010700@gmail.com>
	 <49915832.1090501@tremplin-utc.net>
	 <cb7bb73a0902100307m4eab8ff2nfe9be8bed6a3b5b5@mail.gmail.com>
	 <49917650.1060208@tudelft.nl>
Date: Tue, 10 Feb 2009 21:29:28 +0100
Message-ID: <cb7bb73a0902101229x21cb2e53g17f7e224dd92cd63@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
Cc: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       Palatis Tseng <palatis@gmail.com>, Pavel Machek <pavel@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 1:42 PM, Éric Piel <E.A.B.Piel@tudelft.nl> wrote:
> Giuseppe Bilotta schreef:
>> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
>> (-256,256,14592)
>> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
>> (0,256,14848)
>> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
>> (-256,256,14848)
>> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
>> (-256,0,14336)
>> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
>> (-256,512,14336)
>> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
>> (256,256,14592)
>>
>> Left edge raised:
>> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
>> (5120,512,13312)
>> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
>> (5632,512,13312)
>>
>> You might be onto something.
> Yes, beautiful! All are multiples of 2⁸, so much a sign of MSB/LSB
> inversion! And the good news is that the device just happens to have a
> register to set the endianess: CTRL2/BLE . For now, in the driver, we
> expect the device to be little endian (which is the default according to
> the manual). So at initialization we could force the endianess and see
> if that fix the problem.
>
> Can you try something like this in lis3lv02d_poweron():
>        adev.read(handle, CTRL_REG2, &val);
>        val |= CTRL2_BDU | CTRL2_IEN;
> +       val &= ~CTRL2_BLE;
>        adev.write(handle, CTRL_REG2, val);

I reverted both my patch and the 'minimal init' patch from Pavel, then
added this line. However, it seems to change nothing. Even using
CTRL2_BLE instead of its negation doesn't seem to change much: same
fluctuations, and cat'ing the sysfs file still gives 256, 512 etc.


-- 
Giuseppe "Oblomov" Bilotta
