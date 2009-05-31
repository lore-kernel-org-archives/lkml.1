Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZEaG1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZEaG1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZEaG1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:27:10 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:42268 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZEaG1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VC07fBv5i4fsLwKstneZA9FAEsiM/txcqu0Fik/qcHJN/I4MLjQMrNxPYDkT7IevRX
         Q47dnc/71lSyYisvL69C2CA8+hqwDUp1u/uL6wdKAGINpwUT0rR2YpYEEblYm8jfEjKA
         kjQXdDJxuHesZ/esC6psfSqRf49EDt0uGZEX4=
MIME-Version: 1.0
In-Reply-To: <20090531023556.GB9033@oblivion.subreption.com>
References: <20090531015537.GA8941@oblivion.subreption.com>
	 <alpine.LFD.2.01.0905301902530.3435@localhost.localdomain>
	 <20090531023556.GB9033@oblivion.subreption.com>
Date: Sun, 31 May 2009 09:27:09 +0300
X-Google-Sender-Auth: 53ba4917592333ca
Message-ID: <84144f020905302327t36966003ufce87cf646d649a6@mail.gmail.com>
Subject: Re: [PATCH] Use kzfree in tty buffer management to enforce data 
	sanitization
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Larry H." <research@subreption.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On Sat, 30 May 2009, Larry H. wrote:
>>> This patch doesn't affect fastpaths.

On 19:04 Sat 30 May, Linus Torvalds wrote:
>> This patch is ugly as hell.
>>
>> You already know the size of the data to clear.
>>
>> If we actually wanted this (and I am in _no_way_ saying we do), the only
>> sane thing to do is to just do
>>
>>       memset(buf->data, 0, N_TTY_BUF_SIZE);
>>       if (PAGE_SIZE != N_TTY_BUF_SIZE)
>>               kfree(...)
>>       else
>>               free_page(...)
>>

On Sun, May 31, 2009 at 5:35 AM, Larry H. <research@subreption.com> wrote:
> It wasn't me who proposed using kzfree in these places. Ask Ingo and
> Peter or refer to the entire thread about my previous patches.

Nobody suggested using kzfree() in this _specific_place_. It's obvious
that memset() is a better solution here given the current constraints
of the code as demonstrated by Linus' patch.

                                       Pekka
