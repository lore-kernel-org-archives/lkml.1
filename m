Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZI2AjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZI2AjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZI2AjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:39:10 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49320 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZI2AjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VLIAxPTAv6VGUJqCAO82mlhHT4hI1F1pszqBd1zwuFQbQOtLcwTnMqfagqbPJYXNko
         JsQalGnajd73CiwUgTIp9u7bckR/JpzIEnyWEvT8hvbQfqvrN2z0FRYBVbsVc6BX4HvK
         vkYq5QZ9/q8TPKTKn/S/HWhIJmUVK3UUBYFI0=
MIME-Version: 1.0
In-Reply-To: <200909282220.32582.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0909280202280.14348-100000@netrider.rowland.org>
	 <200909282220.32582.rjw@sisk.pl>
Date: Tue, 29 Sep 2009 08:39:12 +0800
Message-ID: <a8e1da0909281739j516177cfv82dcf0dcb807ce9b@mail.gmail.com>
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

On Tue, Sep 29, 2009 at 4:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 28 September 2009, Alan Stern wrote:
>> On Mon, 28 Sep 2009, Dave Young wrote:
>>
>> > On Mon, Sep 28, 2009 at 2:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > > On Sunday 27 September 2009, Alan Stern wrote:
>> > >> On Sun, 27 Sep 2009, Rafael J. Wysocki wrote:
>> > >>
>> > >> > Tested, works.
>> > >> >
>> > >> > Greg, could you please consider taking the patch below? Â It fixes a recent
>> > >> > hibernation regression for me, so if not this one, another fix is necessary.
>> > >>
>> > >> This patch has a mistake.
>> > >>
>> > >> > Index: linux-2.6/drivers/usb/serial/usb-serial.c
>> > >> > ===================================================================
>> > >> > --- linux-2.6.orig/drivers/usb/serial/usb-serial.c
>> > >> > +++ linux-2.6/drivers/usb/serial/usb-serial.c
>> > >> > @@ -1210,7 +1210,7 @@ static const struct tty_operations seria
>> > >> > Â  Â  .chars_in_buffer = Â  Â  Â serial_chars_in_buffer,
>> > >> > Â  Â  .tiocmget = Â  Â  Â  Â  Â  Â  serial_tiocmget,
>> > >> > Â  Â  .tiocmset = Â  Â  Â  Â  Â  Â  serial_tiocmset,
>> > >> > - Â  .shutdown = Â  Â  Â  Â  Â  Â  serial_release,
>> > >> > + Â  .cleanup = Â  Â  Â  Â  Â  Â  Â serial_release,
>> > >> > Â  Â  .install = Â  Â  Â  Â  Â  Â  Â serial_install,
>> > >> > Â  Â  .proc_fops = Â  Â  Â  Â  Â  Â &serial_proc_fops,
>> > >> > Â };
>> > >>
>> > >> It isn't enough to change the method pointer. Â The code in
>> > >> serial_release() has to be changed too; it must not call tty_shutdown()
>> > >> any more.
>> > >
>> > > Would it be sufficient to remove the tty_shutdown() call from
>> > > serial_release()?
>> >
>> > I think so, because standard shutdown will be called in queue_release_one_tty.
>> >
>> > Alan, could you confirm about this?  Thus I'd like to update the patch.
>>
>> Yes, that's right.  Just remove the function call.  But what happens if
>> the device is a serial console?  Shouldn't the call to tty_shutdown()
>> be skipped in that case?  (Eventually this won't matter; the console
>> code will be straightened out so that we never release a serial console
>> device.  But for now it's important.)
>>
>> If you think it would be appropriate, you could also rename
>> serial_release() to serial_cleanup() -- it's up to you.
>
> The patch has been fixed up by Linus and merged as
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f278a2f7bbc2239f479eaf63d0b3ae573b1d746c
>
> If any more fixes are necessary, they'll have to go on top of it.

Oh, I'm late. Thanks for tell

>
> Best,
> Rafael
>



-- 
Regards
dave
