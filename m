Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZKAXBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZKAXBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 18:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZKAXBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 18:01:05 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:55323 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbZKAXBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 18:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gT9KOJYftuVIDK0U/nKEC1YPB1M8w/XoATuYfSZopgwL87ndfEkWgTj9mVm6jEbzAi
         tcRufGSXvO34l9ypbQ/Bfik4UPAPViYoBf5fbmHK76sTu91PbWmU1CbV5ua6r+jQQ0yB
         hvlM6BfA6I2s3x2cZq+7bJeClED67Pqxx/JlY=
MIME-Version: 1.0
In-Reply-To: <20091101224547.GB5263@nowhere>
References: <b8bf37780911010901i3426f143ve394ae569be74ec1@mail.gmail.com> 
	<20091101224547.GB5263@nowhere>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 1 Nov 2009 21:00:48 -0200
Message-ID: <b8bf37780911011500o741bef51sf8a057e2cedcf22c@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: reduce code size, clean up
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Frederic!

On Sun, Nov 1, 2009 at 8:45 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Sun, Nov 01, 2009 at 03:01:40PM -0200, André Goddard Rosa wrote:
>> +static char null[] = "(null)";
>> +
>
>
> This should be static const.
> Also, may be chose a better name, as "null" is too much
> generic and somehow collide with NULL.
>
> null_str ?
>

If I make it a "static const" it's necessary to cast it in two places
to "char *" and code size goes up

lib/vsprintf.c: In function ‘string’:
lib/vsprintf.c:556: warning: assignment discards qualifiers from
pointer target type
lib/vsprintf.c: In function ‘pointer’:
lib/vsprintf.c:828: warning: passing argument 3 of ‘string’ discards
qualifiers from pointer target type
lib/vsprintf.c:551: note: expected ‘char *’ but argument is of type
‘const char *’

   text    data     bss     dec     hex filename
 15383       7       8   15398    3c26 lib/vsprintf.o-static-before
 15431       0       8   15439    3c4f lib/vsprintf.o-static-const-after

as it moves the variable from data section to code section. Is this
the preferred method?


Thanks for reviewing! I'll fix the other points per your suggestions
and post back.

With regards,
André
