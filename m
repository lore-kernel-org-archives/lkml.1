Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYHRCWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYHRCWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 22:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYHRCWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 22:22:25 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:35272 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750858AbYHRCWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 22:22:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=eX4EqY6CaFJrJJybfJcDfGC4pSDWMl+V5pL3q80Ed0JqkMUn/ZMs+FRcOdJ+C+fZ+UXpOK9nVwZ5bot9IG/i9y6QAqF6GcRSImgi1Aalu2kYzYwJbx0aEjKr22HQhH7SAA7CdCQ6xD6a1uOk9Kpvksk/rW8Re3+ldO8lGWMZHTA=;
X-Mailer: YahooMailWebService/0.7.218
Date: Sun, 17 Aug 2008 19:22:23 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: oakad@yahoo.com
Subject: Re: Problem with find_first_bit function and kin
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <1218974280.18151.1269040199@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <804537.6986.qm@web37604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




--- On Sun, 8/17/08, Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> From: Alexander van Heukelum <heukelum@fastmail.fm>
> Subject: Re: Problem with find_first_bit function and kin
> To: oakad@yahoo.com, "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
> Date: Sunday, August 17, 2008, 4:58 AM
> On Sat, 16 Aug 2008 12:26:54 -0700 (PDT), "Alex
> Dubov" <oakad@yahoo.com>
> said:
> > It's well may be that I'm just missing
> something obvious.
> > 
> > It seems to me that find_first_bit/find_next_bit
> functions return their
> > offsets "base 1" - first set bit is
> "1" and last is "bitmap size". This
> > means that if only the last bit in the bitmap is set,
> the returned value
> > will be indistinguishable from no bits set situation.
> Moreover, bit
> > manipulation functions appear to use "base
> 0" bit addresses, adding to
> > the
> > inconvenience.
> > 
> > Is this a desired behavior? And, if yes, how is one
> supposed to deal with
> > last bit of the bitmap?
> 
> Hi Alex,
> 
> If this is the behaviour you observe, it's a bug. How
> did you
> find out?
> 
> The intended behaviour is that the bits are enumerated in
> "base 0"
> style. If only the last bit in the bitmap is set it should
> return
> bitmapsize-1 and if no bit is set it should return
> bitmapsize.
> Some architecture-specific code gets the last detail wrong,
> they
> return a value that is slightly larger than the bitmap size
> in
> some cases.
> 
> Greetings,
>     Alexander
> -- 

I was compiling some stuff out-of-the tree and got "ffs" linked in instead
of "__ffs", which caused all this weird behavior (on 64b platform). Sorry
for the noise.

But then, why "ffs" behaves differently from "__ffs" and whats the reason
they both exist?



      
