Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbXHTD0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbXHTD0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 23:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXHTD02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 23:26:28 -0400
Received: from smtp106.sbc.mail.re2.yahoo.com ([68.142.229.99]:40124 "HELO
	smtp106.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752661AbXHTD02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 23:26:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=g7JJdMt55jgmPYMfIKU0+be7WOT+XroyhJfzmNvjNzMcBYRoI/2Ag5CxGjlXoEtYc0CwLbAjuTuU00K24K7gH953ccPw4qN2SCJyGKX6En2vi46a1bSRhlAlL8eeyw+IuuQIhYw0rcgJIIatNoqx6dXnoMAM3mYDlcIaiiyUdhk=  ;
X-YMail-OSG: GMtjidMVM1niOAjGOb8mp1mYB0nbWKwDkHktVvNcyuLPSZdDWpEKTY2sZjvcNwsOe3Sc4sBoOQhVtr9cxUqH.RSOyLv8TfwGJUkMOk3nIFB9qrRXqiaAyubeDLUE_0_LQ3XF6qLOKEPEdCA-
From: David Brownell <david-b@pacbell.net>
To: Satyam Sharma <satyam@infradead.org>
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Date: Sun, 19 Aug 2007 20:26:24 -0700
User-Agent: KMail/1.9.6
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070819225546.GV21089@ftp.linux.org.uk> <200708191757.56520.david-b@pacbell.net> <alpine.LFD.0.999.0708200806380.2774@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708200806380.2774@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708192026.24596.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Satyam Sharma wrote:
> > > On a 32-bit arch "unsigned long" is 32-bit and pointers are 32-bit.
> > > 
> > > On a 64-bit archi "unsigned long" is 64-bit and pointers are 64-bit.
> > 
> > So with 32 bit userspace "unsigned long long" is the type to use
> > when talking to a 64-bit kernel; and with pure 64-bit code, it's
> > enough to write "unsigned long".
> > 
> > I'm fairly sure that's the root cause of the pain I recall here;
> > but I'd have to run experiments again to verify that.  
> 
> I suspect the root cause of the pain was that you used "int" or "long"
> to talk between kernel and userspace in the first place. You shouldn't,
> we have __u32 / __u64 / etc for that.

Nope; the relevant code was always with "__u64".  The issue was
warning when turning that into a __user pointer.


> The reason I ask is that gcc will also complain (understandably so) with
> "warning: cast from pointer to integer of different size" i.e. even if
> it's a conversion from smaller size to greater size, and not really a
> case of truncation.

ISTR the warning was the other way around:   about "cast from integer
to pointer of a different size".  The __u64 came from userspace and
the kernel pointer was only 32 bits.  Not really truncation, but GCC
could not know that directly ... ergo the extra non-pointer cast.


