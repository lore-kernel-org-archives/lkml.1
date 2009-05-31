Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZEaGY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZEaGY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZEaGYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:24:22 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:54225 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZEaGYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q4t2maLyAWeduH8P1dPHbdKC2/Rie6cnGk+I9qEmqNAEepTTIM+SLnaXbLvWxFoogN
         sxDJiiQ79F0GVF989HbD+k7r3mLA3JBje8ahJVkcRvLY/OiQDV2RyzfAxmQ5ik3syjnD
         iGrHqAQIUGV+sHyYMeW9UCZll9agSEqvwRC4I=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0905301902530.3435@localhost.localdomain>
References: <20090531015537.GA8941@oblivion.subreption.com>
	 <alpine.LFD.2.01.0905301902530.3435@localhost.localdomain>
Date: Sun, 31 May 2009 09:24:22 +0300
X-Google-Sender-Auth: f5a836039fd9ed22
Message-ID: <84144f020905302324r5e342f2dlfd711241ecfc8374@mail.gmail.com>
Subject: Re: [PATCH] Use kzfree in tty buffer management to enforce data 
	sanitization
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, 30 May 2009, Larry H. wrote:
>>
>> This patch doesn't affect fastpaths.

On Sun, May 31, 2009 at 5:04 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This patch is ugly as hell.
>
> You already know the size of the data to clear.
>
> If we actually wanted this (and I am in _no_way_ saying we do), the only
> sane thing to do is to just do
>
>        memset(buf->data, 0, N_TTY_BUF_SIZE);
>        if (PAGE_SIZE != N_TTY_BUF_SIZE)
>                kfree(...)
>        else
>                free_page(...)
>
>
> but quite frankly, I'm not convinced about these patches at all.

I wonder why the tty code has that N_TTY_BUF_SIZE special casing in
the first place? I think we can probably just get rid of it and thus
we can use kzfree() here if we want to.

                                 Pekka
