Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967827Ab0B0Eea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 23:34:30 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42446 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967794Ab0B0Ee3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 23:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pQYIhQ7ER4RlQreHGUywzowmr5Jr2TZZkzAoW1IeSc4ZUGW9o5E/nTqy5iHn9t4t2T
         VwEK5l461dhyWwMg8q9skx0+e9ZW5wqC+CTSSiYsQJ3cckqPsxctjh58JI2/p9w6mI3k
         FfuDP5ioiNJlyMhD7qJ1p9KX2xgjHnQGcI05M=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002262022090.4513@localhost.localdomain>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
	 <20100227035639.GA11680@kroah.com>
	 <d9def9db1002262005t6d63b902s673fb01dac228e4d@mail.gmail.com>
	 <20100227041815.GA12956@kroah.com>
	 <alpine.LFD.2.00.1002262022090.4513@localhost.localdomain>
Date: Sat, 27 Feb 2010 05:34:27 +0100
Message-ID: <d9def9db1002262034p55cd569n6c423741c276798d@mail.gmail.com>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
From: Markus Rechberger <mrechberger@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       werner@guyane.dyn-o-saur.com, Marcus Meissner <meissner@suse.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 5:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 26 Feb 2010, Greg KH wrote:
>>
>> Yes, and that patch didn't touch the iso frames.  That happens later on
>> in the functions that were modified.  The patch should not have had any
>> affect on iso transfers.  Unless I'm missing something?
>
> Hmm. What seems to happen is that for an isochronous transfer, the buffer
> is split for each microframe. No?
>

exactly. and each microframe has its own buffer length identifier.

the current behaviour breaks VMware, QEMU and virtualbox .. probably
other things too.


> So the total length may be in 'urb->actual_length', but the actual data in
> the buffer may not be contiguous, because it's created from multiple
> smaller frames, some of which might not be full length?
>

yes, it's only contiguous for BULK.

> I dunno. That would explain the problem - actual_length is correct, but
> the 'copy_to_user()' still doesn't copy all the data, because it's
> fragmented.
>

no you got it, but your patch does not work. The best way would be to
revert it if someone wants to speed up BULK it should go down another
path, leaving the old working implementation untouched.

Markus
