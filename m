Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZFURLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZFURLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZFURLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:11:34 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:56873 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZFURLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HRZ/BxxQZkUyrxW7EbzNZDrFQAuyDipNPCSdOt/Ohos4dmji3B6TGiFH4LOHDf6rR7
         xN0vXZxqbAhIeNYIv/ShawAMz9Ons5/BbFXljhb21w4SB/hSt1+IYxjWPrXmNz6hCKbi
         dQogEBrtl20aC25riPYNuB/ahkL86wni1656o=
Message-ID: <4A3E68CD.6080803@gmail.com>
Date: Sun, 21 Jun 2009 19:07:25 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
References: <4A33A7EC.6070008@gmail.com> <20090613140459.GC30053@uranus.ravnborg.org> <200906140059.57362.arnd@arndb.de>
In-Reply-To: <200906140059.57362.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-1
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

I was thinking about your comment and I think I'll use __kernel_off_t
for the exported headers. I know that it will differ between 32 and 64
bit architectures, but for this kind of fs there isn't any compatibility
problem at layout level. You cannot remove a chip of RAM from a board
32bit little endian and attach it to a board with a cpu 64bit big
endian, the memory isn't a disk. Indeed, I see that tmpfs uses simply
"unsigned long" in the exported header file without any problems to
little or big endian.

Regards,

Marco
