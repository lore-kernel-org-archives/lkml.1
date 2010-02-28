Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031737Ab0B1KES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 05:04:18 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33370 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031720Ab0B1KEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=x2WxToNhpbJgI9PVJbYCEvZHUy7BZEikdxVbgoYGSe3rUN+7aCD6U5UuNpC95VNFzx
         s3FcsOHTqZ5s9LVhwfwSODbYcZRo1oA8uox75Nlh+AIuoWIXkguoJuQ4DPCCVjBajv5u
         iFGKSZoPxpAf/aVUvytT5nLaGPJ69Hbr6Auco=
MIME-Version: 1.0
In-Reply-To: <961aa3351002250629p11fc4a49m60aadbf79fc10696@mail.gmail.com>
References: <1266934273-9371-1-git-send-email-akinobu.mita@gmail.com>
	 <20100224162152.GK3687@quack.suse.cz>
	 <961aa3351002241738r7bbdc811p1fe80aabc336ae85@mail.gmail.com>
	 <10f740e81002250050g287f7753g96063376ecee9487@mail.gmail.com>
	 <961aa3351002250629p11fc4a49m60aadbf79fc10696@mail.gmail.com>
Date: Sun, 28 Feb 2010 11:04:12 +0100
X-Google-Sender-Auth: e5cc3511b46e2bfe
Message-ID: <10f740e81002280204q2849317bj3e7d22c5c0c93333@mail.gmail.com>
Subject: Re: [PATCH] udf: use ext2_find_next_bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 15:29, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2010/2/25 Geert Uytterhoeven <geert@linux-m68k.org>:
>> On Thu, Feb 25, 2010 at 02:38, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>>> 2010/2/25 Jan Kara <jack@suse.cz>:
>>>> On Tue 23-02-10 23:11:13, Akinobu Mita wrote:
>>>>> Use ext2_find_next_bit (generic_find_next_le_bit) to find the set bit
>>>>> in little endian bitmap region.
>>
>> Is any of this in linux-next now?
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/2208481/
>> | fs/udf/balloc.c:274: error: implicit declaration of function
>> 'generic_find_next_le_bit'
>
> Yep, Jan's patch caused the build breakage.
>
> Because generic_find_next_le_bit() is not available for all
> archtectures. So we should use ext2_find_next_bit() here.

Most architectures use the definitions in asm-generic, so they're OK.
M68k doesn't. S390 is also affected, and I think arm as well (but there's no
arm all-modconfig build in linux-next, so I'm not 100% sure).

I'm cooking a patch...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
