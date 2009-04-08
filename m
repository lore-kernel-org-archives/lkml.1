Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbZDHHUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbZDHHUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZDHHUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:20:40 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56506 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZDHHUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:20:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UYmIuaa18/iV/9F3OPu3+5YxvuSNZRoTgU/7GepvSXo1fby+lwi54tcuUUmXQNA1+4
         UMUltdKyMnojZKb2KZuT4Wr/+3Vf+QL8DPtl4zB0VOaeWuyW69qRgKSnXrh0y1urpKbd
         ut1kvuTzx02swO4vLIfIg2jwfxcpmBDCnjgNk=
MIME-Version: 1.0
In-Reply-To: <b7997bdf0904071248t48fed168r7fa21b421c74358a@mail.gmail.com>
References: <b7997bdf0904071248t48fed168r7fa21b421c74358a@mail.gmail.com>
Date: Wed, 8 Apr 2009 09:20:37 +0200
Message-ID: <19f34abd0904080020l4f013b58va37c452b91831f85@mail.gmail.com>
Subject: Re: splice lost data
From: Vegard Nossum <vegard.nossum@gmail.com>
To: xinglp <xinglp@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/7 xinglp <xinglp@gmail.com>:
> 2.6.29.1 in VM
>
> When recv data more than 8K (1024*8) bytes at once, data lost happen.
>

Don't know if this is related to the problem you report, but your code is buggy.

You're checking errno before you know that splice() returned -1. Now,
I don't know the actual implementation, but as with most system calls,
the interface specifies only that errno is updated when the function
returns -1:

       "On error, splice() returns -1 and errno is set to indicate the
error." (man 2 splice)

You're also not checking explicitly for the return value 0, which
would possibly also not set errno (i.e. you're using perror() in the
case where splice() returned 0).

Please let me know if this fixes your problem!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
