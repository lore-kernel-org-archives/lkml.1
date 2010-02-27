Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967801Ab0B0EFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 23:05:45 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51622 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967791Ab0B0EFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 23:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X4p7Lgne8vFTCeSpkbL/sd6EzyQh/8elLSIsG4A/V0HYaAnvZU+i58UB7In3q1Lrzf
         FYMxzhK6EmwLyhTS3XvbqGP2oqn5aRfTOslSpRiP1bJMxgGlsrAA9tIFAgp88SpnVr2r
         KKck4LLWNGLmHpTgpe/p0/fIN93q1b91E+Trk=
MIME-Version: 1.0
In-Reply-To: <20100227035639.GA11680@kroah.com>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
	 <20100227035639.GA11680@kroah.com>
Date: Sat, 27 Feb 2010 05:05:41 +0100
Message-ID: <d9def9db1002262005t6d63b902s673fb01dac228e4d@mail.gmail.com>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: werner@guyane.dyn-o-saur.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 4:56 AM, Greg KH <greg@kroah.com> wrote:
> On Sat, Feb 27, 2010 at 04:42:53AM +0100, Markus Rechberger wrote:
>> * http://lkml.org/lkml/2010/2/19/192
>> .6.32-stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>> From: Greg KH <greg@kroah.com>
>>
>> commit d4a4683ca054ed9917dfc9e3ff0f7ecf74ad90d6 upstream.
>>
>> We need to only copy the data received by the device to userspace, not
>> the whole kernel buffer, which can contain "stale" data.
>>
>> Thanks to Marcus Meissner for pointing this out and testing the fix.
>>
>> Reported-by: Marcus Meissner <meissner@suse.de>
>> Tested-by: Marcus Meissner <meissner@suse.de>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>>
>> this patch breaks isochronous USBFS support, please revert that patch!
>>
>> http://sundtek.de/images/tvtime-bildfehler.jpg
>>
>> with the patch reverted:
>> http://sundtek.de/images/tvtime-working.png
>>
>> * Intel graphic flickers now
>
> That is very strange.  What userspace program is using usbfs for video
> feeds?  And why would it be relying on the invalid data on the end of an
> urb?
>

there are 2 userspace videowrapper available for linux and freebsd
which do videoprocessing in userland rather than in kernelspace.
Well isochronous works slightly different than BULK transfer (which I
guess was tested)
urb->iso_frame_desc[i].actual_length
each microframe has it's own length field for ISO.

Markus
