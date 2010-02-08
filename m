Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab0BHND0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 08:03:26 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:58069 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0BHNDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 08:03:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=iwQWd0GcBSvsjhAeLdETmUM+rTPSzdMFVYzB8reyrcl+F9l6FMyBuOipC5WBKVAQtx
         q6gjY4hIeI9aHB1KPSrYyxWaQ3vwkxqJdxY6PAsOxz/QF3odI40/hZbAFX14srL/qPPb
         bUDrkFflR1dqNsYj4sW/uGchcqnud5wwZGTKU=
MIME-Version: 1.0
In-Reply-To: <1265633893.4020.72.camel@pc1117.cambridge.arm.com>
References: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
	 <84144f021002080454j2db78133veda0c50a7eff7e6f@mail.gmail.com>
	 <1265633893.4020.72.camel@pc1117.cambridge.arm.com>
Date: Mon, 8 Feb 2010 15:03:22 +0200
X-Google-Sender-Auth: c18a50c571356d45
Message-ID: <84144f021002080503l5d1d1667xeb1fb4d72fabeadd@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: Test the full object in kmemcheck_is_obj_initialized()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Casteyde <casteyde.christian@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 2:58 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Mon, 2010-02-08 at 12:54 +0000, Pekka Enberg wrote:
>> On Mon, Feb 8, 2010 at 1:16 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > This is a fix for bug #14845 (bugzilla.kernel.org). The
>> > update_checksum() function in mm/kmemleak.c calls
>> > kmemcheck_is_obj_initialised() before scanning an object. When
>> > KMEMCHECK_PARTIAL_OK is enabled, this function returns true. However,
>> > the crc32_le() reads smaller intervals (32-bit) for which
>> > kmemleak_is_obj_initialised() may be false leading to a kmemcheck
>> > warning.
>> >
>> > Note that kmemcheck_is_obj_initialized() is currently only used by
>> > kmemleak before scanning a memory location.
>> >
>> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> > Cc: Andrew Morton <akpm@linux-foundation.org>
>> > Cc: Christian Casteyde <casteyde.christian@free.fr>
>> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>> > Cc: Vegard Nossum <vegardno@ifi.uio.no>
>>
>> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> Andrew, Vegard has been rather quiet lately so do you mind picking up
>> this patch? Alternatively, I can pick it up in slab.git if you so
>> prefer.
>
> It's been pretty late indeed, sorry about that (I mostly work on ARM
> hardware where kmemcheck isn't available and couldn't test the patch
> earlier).
>
> Anyway, IMHO it's not critical to be merged in 2.6.33 but it's up to
> you.

I think it's definitely .34 material but probably should go to -stable.

                        Pekka
