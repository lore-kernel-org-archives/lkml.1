Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbZI1FDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbZI1FDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 01:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZI1FDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 01:03:50 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:62481 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZI1FDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 01:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bWGTWRRq+dUif0M4Oy7ld4Yb4bXw0YcgaiD7CsdzC7wa6Ks5MeZ6/hd5q4qVNJZ1N5
         xDdITWZG/kzjYuEeQpsgE9W0PwAcKcSli/QX0zumNRRDNEgq4hguqeJDcAGHjT7AFni6
         vUn6JE7bLhpUBCYA23l8WizlndSk6omOwjsVw=
MIME-Version: 1.0
In-Reply-To: <200909272016.04597.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0909271329400.5871-100000@netrider.rowland.org>
	 <200909272016.04597.rjw@sisk.pl>
Date: Mon, 28 Sep 2009 13:03:52 +0800
Message-ID: <a8e1da0909272203me287858y2f8d82f3710e07d3@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH, fix] Re: [Regression] 2.6.31-git: tty change 
	broke resume from hibernation on MSI Wind U100
From: Dave Young <hidave.darkstar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 2:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 27 September 2009, Alan Stern wrote:
>> On Sun, 27 Sep 2009, Rafael J. Wysocki wrote:
>>
>> > Tested, works.
>> >
>> > Greg, could you please consider taking the patch below?  It fixes a recent
>> > hibernation regression for me, so if not this one, another fix is necessary.
>>
>> This patch has a mistake.
>>
>> > Index: linux-2.6/drivers/usb/serial/usb-serial.c
>> > ===================================================================
>> > --- linux-2.6.orig/drivers/usb/serial/usb-serial.c
>> > +++ linux-2.6/drivers/usb/serial/usb-serial.c
>> > @@ -1210,7 +1210,7 @@ static const struct tty_operations seria
>> >     .chars_in_buffer =      serial_chars_in_buffer,
>> >     .tiocmget =             serial_tiocmget,
>> >     .tiocmset =             serial_tiocmset,
>> > -   .shutdown =             serial_release,
>> > +   .cleanup =              serial_release,
>> >     .install =              serial_install,
>> >     .proc_fops =            &serial_proc_fops,
>> >  };
>>
>> It isn't enough to change the method pointer.  The code in
>> serial_release() has to be changed too; it must not call tty_shutdown()
>> any more.
>
> Would it be sufficient to remove the tty_shutdown() call from
> serial_release()?

I think so, because standard shutdown will be called in queue_release_one_tty.

Alan, could you confirm about this?  Thus I'd like to update the patch.



>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
