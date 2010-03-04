Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0CDSUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:20:15 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40423 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab0CDSUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q+CkgSTVuXfb3cui3DPUfmOee2ssiT8NO4f1ujQiwSVaTL9xKA8Rs9PP4O668i+ntS
         glRcJ6jJm5iS6cNL0IziMlD5OAnfSHFQhGfvYppTMAAc5rVhfWqVrTG0ViOEJuBLHSDx
         y56PFc+MGQ/fF4OrJG+pBpHpIkn9dr7pxDBC4=
MIME-Version: 1.0
In-Reply-To: <4B8FF2C3.1060808@teksavvy.com>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>
	 <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>
	 <4B8FC6AC.4060801@teksavvy.com>
	 <f875e2fe1003040733h20d5523ex5d18b84f47fee8c7@mail.gmail.com>
	 <4B8FF2C3.1060808@teksavvy.com>
Date: Thu, 4 Mar 2010 13:20:11 -0500
Message-ID: <f875e2fe1003041020t7cbab2c2x585df9b2dfc10dd2@mail.gmail.com>
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
	program
From: s ponnusa <foosaa@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMART data consists only the count of remapped sectors, seek failures,
raw read error rate, uncorrectable sector counts, crc errors etc., and
technically one should be aware of the error during write operation as
well.

As per the ATAPI specifications, the media will report error for both
read / write operations. It times out / sends out error code for both
read and write operations. Correct me if I am wrong. What happens if
all the available free sectors are remapped and there are no more
sectors to map? In that atleast the drive should return an error
right? When using the O_DIRECT more, the i/o error, media bad,
softreset, hardreset error messages are starting to fill up dmesg
almost immediately after the write call.

It just tries in a continous loop and then finally returns success
(even without remapping). I don't know how to change the behavior of
libata / or other such driver which does it. All I want to do it to
know the error in my program while it is reporting it in the syslog at
kernel / driver level.

Thank you.

On Thu, Mar 4, 2010 at 12:49 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 03/04/10 10:33, foo saa wrote:
> ..
>>
>> hdparm is good, but I don't want to use the internal ATA SECURE ERASE
>> because I can never get the amount of bad sectors the drive had.
>
> ..
>
> Oh.. but isn't that information in the S.M.A.R.T. data ??
>
> You'll not find the bad sectors by writing -- a true WRITE nearly never
> reports a media error.  Instead, the drive simply remaps to a good sector
> on the fly and returns success.
>
> Generally, only READs report media errors.
>
> Cheers
>
