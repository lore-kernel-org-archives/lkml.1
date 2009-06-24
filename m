Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZFXGbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZFXGbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZFXGat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:30:49 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64912 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZFXGas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j07eRax6zewi9Q/Im1eITMY9GYROGSeDMJ0HekL425LopoAln/Evbu+FdBcbE54jbo
         MyWuZV57qbkHcQGxANH5VD/pjAtgVqb2jhCVINsuWYEHeuMGCVkXgm9odnydpsVDcZc0
         0u/rnG3rK+fxu9fWMKhq0cM4RwrUm1X23p+qM=
MIME-Version: 1.0
In-Reply-To: <4a4130db.0af6660a.48a9.ffffdace@mx.google.com>
References: <4a4130db.0af6660a.48a9.ffffdace@mx.google.com>
Date: Wed, 24 Jun 2009 08:30:49 +0200
Message-ID: <2ea1731b0906232330u700e8bc0p7b0cafa83d8d2d5a@mail.gmail.com>
Subject: Re: I:Re: [PATCH 06/14] Pramfs: Include files
From: Marco Stornelli <marco.stornelli@gmail.com>
To: joern@lazybastard.org
Cc: sam@ravnborg.org, tim.bird@am.sony.com, Arnd Bergmann <arnd@arndb.de>,
       linux-fsdevel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 23 June 2009 19:38:33 +0200, Marco wrote:
>>
>> dd? You haven't got any device file to have a dump. I think we're going
>> a bit out of scope. I had some doubt to support rootfs in pram and after
>> some feedback and the comments of this review I think I'll remove it
>> from the next release (to understand some aspects of this fs with the
>> kernel community was my main goal for this review). I agree to use the
>> native endian. As I said the important thing is that if an user want to
>> use it in a 64bit environment then the fs must work well and then it
>> must be designed to support even this situation, I think it's obvious.
>
> Glancing at the discussion with Pawel, I see two paths to follow.  One
> is to turn pramfs into a full-features all-round general-purpose
> filesystem with mkfs, fsck, xattr and any number of additional features.
> That way lies doom, as you would compete against ext2+xip and have
> little new to offer.
>
> The other path is to make/keep pramfs as simple as possible for
> comparatively specialized purposes, like flight recorder data and dump
> information.  Main selling point here is the amount of vulnerable code
> in the total package.  ext2 + block layer + vfs helpers is relatively
> large and many things may go wrong in a panic situation.
>
> So I agree with you that many things expected from general purpose
> filesystems simply don't apply to pramfs.  Moving mkfs into the kernel
> is a fair tradeoff, when the required code is small.  Endianness is a
> different case imo.  dd may not work, but a jtag probe will happily get
> you the dump to your development machine.
>

I quite agree, but I'd like to say that it was _not_ my intention to
submit a general-purpose fs comparable with ext2 or ext3.


> And even within the same box you can have more than one architecture and
> endianness.  http://www.top500.org/system/9707 will show you one such
> beast, which happens to have the top bragging rights at the moment.  I
> don't want to endorse such strange beasts, but there is no good reason
> not to support reading the ppc-written fs from the opteron.  In fact,
> there is no reason full stop.
>
> Jörn
>

Mmm....Jtag dump makes more sense, ok in the next release I rework the
layout to have an independent endianess layout.

Marco
