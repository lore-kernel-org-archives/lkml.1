Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZFNHUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZFNHUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZFNHTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:19:48 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47489 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZFNHTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OmPoNkNd+XxATQ/ab0sS/pV9aXEeCsQmthScxg+qUCjM8e0qANsfpHZBDE3Xb29zOi
         r1ks8q7STIpWD/BnqQ+8WpxBHCdeUdFdGrh4gL8DuUiOq3dS7+G4FsfvPTwwxQKav5Me
         PLncdBakw8FcwFA5+TziSLdXBbOGWoSlOIyKk=
Message-ID: <4A34A3A6.3080604@gmail.com>
Date: Sun, 14 Jun 2009 09:15:50 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 06/14] Pramfs: Include files
References: <4A33A7EC.6070008@gmail.com> <20090613140459.GC30053@uranus.ravnborg.org> <200906140059.57362.arnd@arndb.de>
In-Reply-To: <200906140059.57362.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Saturday 13 June 2009, Sam Ravnborg wrote:
>>> +     union {
>>> +             struct {
>>> +                     /*
>>> +                      * ptr to row block of 2D block pointer array,
>>> +                      * file block #'s 0 to (blocksize/4)^2 - 1.
>>> +                      */
>>> +                     off_t row_block;
>> It is my understanding that we shall use: __kernel_off_t
>> in exported headers.
> 
> That is a correct understanding in general, however this case is
> different, because it describes an on-disk data structure,
> not a kernel to user space interface. Here, __kernel_off_t is just
> as wrong as off_t, because it will differ between 32 and 64 bit
> architectures, making the fs layout incompatible. I'd suggest
> simply defining this as __u64.
> 
> Moreover, file system layout should be described in terms of
> big-endian or little-endian types (e.g. __be64 or __le64),
> together with the right accessor functions.
> 
> 	Arnd <><
> 

Yep, you're right. I have to change the definition to be compatible
between 32 and 64 bit archs.

Marco

