Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZCUMLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZCUMLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZCUMLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:11:07 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60460 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbZCUMLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=T9hZB1L0vrdhK24Q0920zP5HDEu8/dQOP1DEg+NAVSIkZM442NNPjSN579Rsns6MVg
         m2UvRKa5Jew+cAwgfxphjsHSwtp2JVH6+cBJxko4wNQhivLK9zEH7WuPuco6zm1w24fJ
         Ue9DjR9IZRo8XA89QRXMA0liWxf0J0yO+i5kY=
MIME-Version: 1.0
In-Reply-To: <20090321113315.47562aac@neptune.home>
References: <20090321113315.47562aac@neptune.home>
Date: Sat, 21 Mar 2009 13:11:01 +0100
X-Google-Sender-Auth: 700ee02db90e9556
Message-ID: <10f740e80903210511n2867e7adl11fda0f4af04b0d2@mail.gmail.com>
Subject: Re: SquashFS io errors - zlib_inflate tried to decompress too much 
	data
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: phillip@lougher.demon.co.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 11:33, Bruno Prémont <bonbons@linux-vserver.org> wrote:
>
> With 2.6.29-rc7-git5 (x86, 32bit) I get the following errors on assumed
> correct squashfs images (generated with mksquashfs from CVS, dated
> 2009-03-14)
>
> [ 3481.692558] SQUASHFS error: zlib_inflate tried to decompress too much data, expected 8192 bytes.  Zlib data probably corrupt
> [ 3481.692571] SQUASHFS error: squashfs_read_data failed to read block 0x29375e0
> [ 3481.692579] SQUASHFS error: Unable to read metadata cache entry [29375e0]
> [ 3481.692586] SQUASHFS error: Unable to read inode 0x6a04a05ed
>
> The same happens on 2.6.28.8 with all squashfs patches from 2.6.29-rc8
> applied to it (x86, 64bit).

A fix for this has entered mainline:

commit 363911d027d1de1c6df79eb3f487f5476b9619f4
Author: Phillip Lougher <phillip@lougher.demon.co.uk>
Date:   Thu Mar 12 03:23:48 2009 +0000

    Squashfs: Valid filesystems are flagged as bad by the corrupted fs patch

Gr{oetje,eeting}s,

                                                                  Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
   -- Linus Torvalds
