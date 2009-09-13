Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZIMHkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZIMHkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 03:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZIMHkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 03:40:01 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:34106 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZIMHkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 03:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QKMbLA8Ix8ox6SoizHHwBaeKaQXT6xdakMGSoP8smviCZUnyehqKxUnsOAAsPQCPZ4
         GI4riF+Gvv/6WH1JlkVdNMgUvXd0v+toBh/qX+nB55zsOuLvvQUMBvPtXuMEBNmFIrrr
         gKCAacugIKJ4F35UsDtfQNtQHzVkJWrGTxI1E=
MIME-Version: 1.0
In-Reply-To: <4AABBB41.40208@windriver.com>
References: <alpine.DEB.2.00.0909112214370.15464@ayla.of.borg>
	 <4AABBB41.40208@windriver.com>
Date: Sun, 13 Sep 2009 09:40:03 +0200
X-Google-Sender-Auth: 290843c6a81080eb
Message-ID: <10f740e80909130040o4c8f89a1y40da5f222f27e0b5@mail.gmail.com>
Subject: Re: [PATCH] kgdb: Replace strstr() by strchr() for single-character 
	needles
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 17:16, Jason Wessel <jason.wessel@windriver.com> wrote:
> I think the patch is fine and I will accept it into the kgdb tree for
> pushing to Linus, but I did have a question.
>
> How did the kgdbts.o end up getting compiled on m68k if there is no kgdb
> support on m68k?

It didn't. I was just grepping for the problematic strstr() case.

> Geert Uytterhoeven wrote:
>> Some versions of gcc replace calls to strstr() with single-character
>> "needle" string parameters by calls to strchr() behind our back.
>> This causes linking errors if strchr() is defined as an inline function
>> in <asm/string.h> (e.g. on m68k, which BTW doesn't have kgdb support).
>>
>> Prevent this by explicitly calling strchr() instead.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> This is the single remaining case where strstr() is used with a
>> single-character needle.  Cfr.
>> commit 0d03d59d9b31cd1e33b7e46a80b6fef66244b1f2 ("md: Fix "strchr"
>> [drivers/md/dm-log-userspace.ko] undefined!")
>> commit d8b0fb51ef1563c631d26cb649a5479b5cc4899c ("[PATCH] libertas link error
>> due to gcc `smartness'")

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
