Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZK1UOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZK1UOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 15:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbZK1UO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 15:14:29 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:39149 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZK1UO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 15:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jk/VYIkh094hYgTlsW9P0zcoYTF8MmHtXUQvlH5h3hZ0F2SYKJ5ljYKAkxgYKjBU+d
         lisMVuw3CVXHYVVOonpupuNYyl9FeC5wB9rzxJ5lCF3J9LJXR/GnzufQ4889NiGYxTMO
         6BOJBn55qEFwmHNQsniY1XyA2gEMlqj8Sp/Q0=
MIME-Version: 1.0
In-Reply-To: <m3ws1awhk8.fsf@intrepid.localdomain>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <4B116954.5050706@s5r6.in-berlin.de>
	 <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
	 <m3ws1awhk8.fsf@intrepid.localdomain>
Date: Sat, 28 Nov 2009 15:14:32 -0500
Message-ID: <9e4733910911281214o614fd912wbbe5dcc50108aeea@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
       dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 2:55 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Jon Smirl <jonsmirl@gmail.com> writes:
>
>> EVIOCSKEYCODE is lacking, first parameter is an INT. Some decoded IR
>> codes are over 32b. Christoph posted an example that needs 128b.
>
> This only means that the existing interface is limited.
>
>> This
>> is a problem with ioctls, they change size depending on platform and
>> endianess.
>
> But not this: you can use fixed-width u16, u32, u64 and e.g. u8[x].
> I don't know an arch which changes int sizes depending on endianness,
> is there any?

Endianess comes into play when send/receiving multibyte integers on
platforms with different endianess.  That where the hton() stuff comes
from. IOCTLs obviously work, you just have to allow for all of this
stuff when writing them.

http://linux.die.net/man/3/htonl


> 32/64 binary compatibility needs some minimal effort.
> --
> Krzysztof Halasa
>



-- 
Jon Smirl
jonsmirl@gmail.com
