Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYIARZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYIARZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbYIARZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:25:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:42508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYIARZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QhSobdEd43qsF4A78bW4wS5y0wIwmpu0QScoR6Bmqq33JXxUIJyj1IMdC41fMG5C8P
         eit1ruzpgCyUlhj624GFVJD4e49MyL8qoT9mlqvfxNl/O58B08FWD6/EJoskjluGVEva
         NGPCnI0DApOWzRMvOTy+4xeGC46vDTggZZL5o=
Message-ID: <86802c440809011025ue34800w179ee03d2cf214d1@mail.gmail.com>
Date: Mon, 1 Sep 2008 10:25:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: mtrr madness
Cc: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48BC2405.9070403@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.oAfJTOqZ/UBF74k5hFotOE73/z4@ifi.uio.no>
	 <48BC2405.9070403@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2008 at 10:19 AM, Robert Hancock <hancockr@shaw.ca> wrote:
> Lukas Hejtmanek wrote:
>>
>> Hello,
>>
>> it seems that all linux kernels contain a bug with mtrr:
>>
>>  cat /proc/mtrr reg00: base=0x00000000 (   0MB), size=198656MB:
>> write-back, count=1
>> reg01: base=0x80000000 (2048MB), size=197120MB: write-back, count=1
>> reg02: base=0x9fc00000 (2556MB), size=196612MB: uncachable, count=1
>> reg03: base=0x100000000 (4096MB), size=200704MB: write-back, count=1
>> reg04: base=0x200000000 (8192MB), size=204800MB: write-back, count=1
>>
>> (watch the size)
>>
>> it is definitely  present in the kernels 2.6.16, 2.6.24, 2.6.25, 2.6.26.
>>
>> 198656 is 0x3080000000, the correct value would be 0x80000000, similarly
>> 197120 is 0x3020000000, the correct would be 0x20000000.
>
> Those are set up by the BIOS, so it would be what's at fault. I think we may
> be adding something to fix this up though?

the fix is in mainline already...,
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Thu Aug 21 20:24:24 2008 -0700

    x86: work around MTRR mask setting

please try 2.6.27-rc5...

YH
