Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbXKLM5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbXKLM5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 07:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbXKLM5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 07:57:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:16272 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbXKLM5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 07:57:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pHFq3vCSxQTOFBOk0NWZPUbmLGxo+3AbYp10omYVvt9RdJII7FzhBb8acSmXknNb2syToUcFUw+HieSjJjHSsI3/3kYVZNKlTqUfjvnlyDjmUJig5aQuSJ2uYyNUBSjExemV5VeILx65oHShWmKtto66BtjfDS8W5/Zbe5Cu0yw=
Message-ID: <19f34abd0711120457x720f0ac8q9d6d0632e6a970fb@mail.gmail.com>
Date: Mon, 12 Nov 2007 13:57:04 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andreas Schwab" <schwab@suse.de>
Subject: Re: [PATCH] Include header required for INT_MAX
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, axboe@kernel.dk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <je1wav3bxh.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
	 <jeabpj3fn1.fsf@sykes.suse.de>
	 <alpine.LFD.0.9999.0711120551380.23072@localhost.localdomain>
	 <je1wav3bxh.fsf@sykes.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 12, 2007 1:06 PM, Andreas Schwab <schwab@suse.de> wrote:
> "Robert P. J. Day" <rpjday@crashcourse.ca> writes:
>
> > On Mon, 12 Nov 2007, Andreas Schwab wrote:
> >
> >> Jan Engelhardt <jengelh@computergmbh.de> writes:
> >>
> >> > No, because I be damn sure that some developers try compiling programs
> >> > in non-linux environments (cygwin, solaris, andyourpersonaldistro, you
> >> > name it) which do not have to adhere to <limits.h>. It might use
> >> > <cosmiclimits.h> instead, or whatever.
> >>
> >> Every C compiler has <limit.h>.
> >
> > i'm assuming you mean <limits.h>, no?
>
> Yes, sorry for the typo.

This seems like a good time to ask why the kernel doesn't use
<stdint.h> for its INT_MAX and type definitions like uint32_t., etc.
>From the manpage: "The <stdint.h> header is a subset of the
<inttypes.h> header more suitable for use in freestanding
environments, which might not support the formatted I/O functions. In
some environments, if the formatted conversion support  is  not
wanted,  using this header instead of the <inttypes.h> header avoids
defining such a large number of macros."

limits.h, on the other hand, seems to define a lot of
userspace-related things like ARG_MAX, ATEXIT_MAX. Or BC_BASE_MAX
(Maximum obase values allowed by the bc utility.). Which have nothing
to do with the kernel at all.

So even though another header is mentioned (inttypes.h), the argument
in favour of using stdint.h still holds; it defines the subset of
macros/types that is suitable in a freestanding environment (i.e. the
kernel).

Vegard
