Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098Ab0A0Itf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0A0Itf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008Ab0A0Ite
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:49:34 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:45437 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab0A0Ite convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:49:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E/BqmnsjQ7XG9QxThE0p4qzMpmzl7UsULyjOaN2fjagiHQ1Kd1IMueS7Akh6oR4CVE
         GpFqPxNrWaWUlTlaf8MP3hvyRXtgi1VsYb7vOHmQvr/BmTZ5cvw6sAPH8WVDT+3J7emw
         KOVCTB2Ye7K6HqgJ8Q5x5sxpQEZRVQ7baVBmU=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1001262342240.30977@pobox.suse.cz>
References: <b0ae6fcc1001200359y8779182j76f92b50924b340b@mail.gmail.com> 
	<alpine.LNX.2.00.1001262342240.30977@pobox.suse.cz>
From: Shahar Havivi <shaharh@gmail.com>
Date: Wed, 27 Jan 2010 10:49:11 +0200
Message-ID: <b0ae6fcc1001270049m6e2e7b1dre9971e57e282b48a@mail.gmail.com>
Subject: Re: [PATCH] Remove unused variables
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused fields in drivers/char/vt.c
variables orig_buf and orig_count are assigned but never used.

Signed-off-by: Shahar Havivi <shaharh@gmail.com>
---
 drivers/char/vt.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 50faa1f..94f530a 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2119,8 +2119,6 @@ static int do_con_write(struct tty_struct *tty,
const unsigned char *buf, int co
    uint8_t inverse;
    uint8_t width;
    u16 himask, charmask;
-   const unsigned char *orig_buf = NULL;
-   int orig_count;

    if (in_interrupt())
        return count;
@@ -2142,8 +2140,6 @@ static int do_con_write(struct tty_struct *tty,
const unsigned char *buf, int co
        release_console_sem();
        return 0;
    }
-   orig_buf = buf;
-   orig_count = count;

    himask = vc->vc_hi_font_mask;
    charmask = himask ? 0x1ff : 0xff;
-- 
1.6.3.3

On Wed, Jan 27, 2010 at 12:43 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 20 Jan 2010, Shahar Havivi wrote:
>
>> Remove unused fields in drivers/char/vt.c
>> variables orig_buf and orig_count are assigned but never used.
>> Shahar Havivi
>
> Could you please resend with your Signed-off-by line, as described in
> Documentation/SubmittingPatches, so that I could apply the patch?
>
>> ---
>>  drivers/char/vt.c |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
>> index 50faa1f..94f530a 100644
>> --- a/drivers/char/vt.c
>> +++ b/drivers/char/vt.c
>> @@ -2119,8 +2119,6 @@ static int do_con_write(struct tty_struct *tty,
>> const unsigned char *buf, int co
>>     uint8_t inverse;
>>     uint8_t width;
>>     u16 himask, charmask;
>> -   const unsigned char *orig_buf = NULL;
>> -   int orig_count;
>>
>>     if (in_interrupt())
>>         return count;
>> @@ -2142,8 +2140,6 @@ static int do_con_write(struct tty_struct *tty,
>> const unsigned char *buf, int co
>>         release_console_sem();
>>         return 0;
>>     }
>> -   orig_buf = buf;
>> -   orig_count = count;
>>
>>     himask = vc->vc_hi_font_mask;
>>     charmask = himask ? 0x1ff : 0xff;
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>
