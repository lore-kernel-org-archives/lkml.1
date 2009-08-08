Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbZHHDUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbZHHDUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 23:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbZHHDUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 23:20:30 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:56517 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbZHHDU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 23:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GpB6/A5WTnMEMvhaGmLsSlnlcyOhDXIoyX2PyRbVgt7FxiFmX2hlCycCKb90oTwFP6
         YSq+QR35LGtOQWj4GUk/niyVxnHHjtmIYUviXvhnifNGtEtFFj8hG9M2dmQVyCr2yPZB
         a+M+ojYMf3lZjMVlbOxPCa6Ceif47ANI3df/o=
MIME-Version: 1.0
In-Reply-To: <1249657743.32113.733.camel@twins>
References: <20090807094608.4b0efea1@torg> <1249657743.32113.733.camel@twins>
Date: Sat, 8 Aug 2009 11:20:29 +0800
Message-ID: <a8e1da0908072020k45ede762v34b78ea3d3716379@mail.gmail.com>
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
From: Dave Young <hidave.darkstar@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Clark Williams <williams@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       "greg@kroah.com" <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 11:09 PM, Peter Zijlstra<peterz@infradead.org> wrote:
> On Fri, 2009-08-07 at 09:46 -0500, Clark Williams wrote:
>> Peter,
>>
>> I'm getting this warning from lockdep when booting on my T60.
>>
>> The two addresses reported (0xffffffff812664a2 and 0xffffffff812664ae)
>> actually bracket one call to mutex_lock() in driver_attach() so I'm not
>> sure what the complaint is.
>>
>> Clark
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 2.6.31-rc5-rt1.1 #37
>> ---------------------------------------------
>> swapper/1 is trying to acquire lock:
>>  (&dev->mutex){+.+...}, at: [<ffffffff812664ae>]
>> __driver_attach+0x48/0x81
>>
>> but task is already holding lock:
>>  (&dev->mutex){+.+...}, at: [<ffffffff812664a2>]
>> __driver_attach+0x3c/0x81
>>
>> other info that might help us debug this:
>> 1 lock held by swapper/1:
>>  #0:  (&dev->mutex){+.+...}, at: [<ffffffff812664a2>]
>> __driver_attach+0x3c/0x81
>
> Oh, that's tglx who's gone wild with sem->mutex conversions.
>
> It used to be that _all_ dev->sem instances were taken on suspend or
> something like that, I think that got fixed a long while back.
>
> I'd have to look at what the current locking requirements for dev->sem
> are.
>
> I remember talking to Alan on several occasions about this, and I just
> went over some of the old emails, but I must say the precise
> requirements stay hidden from me. Also, I'm not sure these emails are
> still representative of the current state.

I think you means this thread:

http://lkml.org/lkml/2008/4/17/305

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
