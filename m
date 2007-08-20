Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXHTERR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXHTERR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 00:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbXHTERH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 00:17:07 -0400
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:37240 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750899AbXHTERG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 00:17:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xO5FUbF5gQx9FCFkHRFVNTbLmgZ82mjUcCMB8oovdQLcLIibsxPzsSQhxVarwmdF1JGetzRN2v4w9vjQNHycOTjfmp3o2JnvljvaaFsX8lNlh2D3aAkZzj2LASl04ozfIIsvRjkRPkldR2eIaIr40GDazsad79I2lmKN19VqA+Y=  ;
X-YMail-OSG: 9uWvo6kVM1mLkuBRgiQRrTWkpikwqkrpRButr9pCvVJRZTteuEja18_C1FujfHu6XwHm9i7zOw--
From: David Brownell <david-b@pacbell.net>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Date: Sun, 19 Aug 2007 21:17:00 -0700
User-Agent: KMail/1.9.6
Cc: Satyam Sharma <satyam@infradead.org>, Anton Altaparmakov <aia21@cam.ac.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070819225546.GV21089@ftp.linux.org.uk> <200708192026.24596.david-b@pacbell.net> <20070820034043.GZ21089@ftp.linux.org.uk>
In-Reply-To: <20070820034043.GZ21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708192117.00759.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Al Viro wrote:
> On Sun, Aug 19, 2007 at 08:26:24PM -0700, David Brownell wrote:
> 
> > ISTR the warning was the other way around:   about "cast from integer
> > to pointer of a different size".  The __u64 came from userspace and
> > the kernel pointer was only 32 bits.  Not really truncation, but GCC
> > could not know that directly ... ergo the extra non-pointer cast.
> 
> And?  Cast to integer type with the size equal to that of pointer.
> unsigned long is just that on all supported targets.

Some tool kept warning about that.  Presumably then-current sparse.
I've certainly heard the conventional "unsigned long fits pointers"
wisdom, but tools disagreed.  (Does ANSI C guarantee that?  I'd think
not, or uintptr_t would not be needed.)

And ptrdiff_t was the closest relevant data type that passed both
gcc and sparse, since uintptr_t didn't previously exist everywhere.


> More interesting question is whether you want an error returned when
> pointers are 32bit and value doesn't fit into that...

Either access_ok() or copy_from_user() reports an error if the
pointer part of that u64 (N LSBs) is bad.

As a general policy, I think the other part is undefined and
irrelevant to the kernel ... it's a kind of explicit padding,
and padding isn't valdated.  (At most it's zeroed to prevent
a covert channel, but that's not relevent here.)

- Dave

