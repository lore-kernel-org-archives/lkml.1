Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbYHRGx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbYHRGx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYHRGxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:53:18 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54574 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYHRGxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:53:18 -0400
Message-Id: <1219042396.25511.1269137275@webmail.messagingengine.com>
X-Sasl-Enc: S8CxXZ96E0MjlypMFTHiJ9g0N95/TUvyEAnRBNeuQE/k 1219042396
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: oakad@yahoo.com
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <804537.6986.qm@web37604.mail.mud.yahoo.com>
Subject: Re: Problem with find_first_bit function and kin
In-Reply-To: <804537.6986.qm@web37604.mail.mud.yahoo.com>
Date: Mon, 18 Aug 2008 08:53:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 19:22:23 -0700 (PDT), "Alex Dubov" <oakad@yahoo.com>
said:
> --- On Sun, 8/17/08, Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > From: Alexander van Heukelum <heukelum@fastmail.fm>
> > Subject: Re: Problem with find_first_bit function and kin
> > To: oakad@yahoo.com, "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
> > Date: Sunday, August 17, 2008, 4:58 AM
> > On Sat, 16 Aug 2008 12:26:54 -0700 (PDT), "Alex
> > Dubov" <oakad@yahoo.com>
> > said:
> > > It's well may be that I'm just missing
> > something obvious.
> > > 
> > > It seems to me that find_first_bit/find_next_bit
> > functions return their
> > > offsets "base 1" - first set bit is
> > "1" and last is "bitmap size". This
> > > means that if only the last bit in the bitmap is set,
> > the returned value
> > > will be indistinguishable from no bits set situation.
> > Moreover, bit
> > > manipulation functions appear to use "base
> > 0" bit addresses, adding to
> > > the
> > > inconvenience.
> > > 
> > > Is this a desired behavior? And, if yes, how is one
> > supposed to deal with
> > > last bit of the bitmap?
> > 
> > Hi Alex,
> > 
> > If this is the behaviour you observe, it's a bug. How
> > did you
> > find out?
> > 
> > The intended behaviour is that the bits are enumerated in
> > "base 0"
> > style. If only the last bit in the bitmap is set it should
> > return
> > bitmapsize-1 and if no bit is set it should return
> > bitmapsize.
> > Some architecture-specific code gets the last detail wrong,
> > they
> > return a value that is slightly larger than the bitmap size
> > in
> > some cases.
> > 
> > Greetings,
> >     Alexander
> > -- 
> 
> I was compiling some stuff out-of-the tree and got "ffs" linked in
> instead of "__ffs", which caused all this weird behavior (on 64b
> platform). Sorry for the noise.
> 
> But then, why "ffs" behaves differently from "__ffs" and whats the
> reason they both exist?

The difference is that __ffs does base-0 indexing on a long type
and ffs does base-1 indexing on a regular int type. Also, __ffs(0)
is undefined, while ffs(0) returns 0. ffs is the odd one out in the
kernel, but its behaviour is set in stone, because gcc may replace
any call to ffs with its own (usually inlined) version, which
behaves as described.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Email service worth paying for. Try it for free

