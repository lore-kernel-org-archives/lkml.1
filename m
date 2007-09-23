Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXIWRvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXIWRvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 13:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbXIWRvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 13:51:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:38071 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbXIWRvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 13:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cRPP6JEoS00GW1OhN5+q268vi0OB9ENfuQDA7OGORH0e+a9E1U//092loo1afQ1L+42ANgTwNLoJhsFIzCPUcY5SazhqQ4l0+YOD6Vu5P8RLUIDxXJg+1+fD9nRS8XMVsEjY9rRWHrSPjzlNOzmMfCNpXV3hT6BEzfnlO5h9MbE=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Date: Sun, 23 Sep 2007 20:51:39 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709220828.00078.mihai.dontu@gmail.com> <1190542810.3723.27.camel@localhost.localdomain> <200709231937.13595.mihai.dontu@gmail.com>
In-Reply-To: <200709231937.13595.mihai.dontu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709232051.39949.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 September 2007, Mihai Donțu wrote:
> On Sunday 23 September 2007, Benjamin Herrenschmidt wrote:
> > Heh, yup.
> > 
> > There have been some radeonfb patches around -rc6 or so. Can you try
> > backing them out and letting us know if that helps a) ?
> > 
> > In that case, Linus, we probably want to revert them...
> > 
> > Though looking at your PCI ID (5955), I don't think the patches should
> > have changed anything.
> 
> After four hours of bisecting, I got this, which dates back to 2.6.21, but
> I've been on 2.6.21.3 for too long and thus missed the commit (I just decided
> to be a good citizen and test things before they get out).
> 
> dd1447134454b169d5ae353aceb93f2368db8547 is first bad commit
> commit dd1447134454b169d5ae353aceb93f2368db8547
> Author: johan henriksson <jhn98032@gmail.com>
> Date:   Tue May 8 00:37:59 2007 -0700
> 
>     radeonfb: Add support for Radeon xpress 200m
> 
>     Added support for radeon xpress 200m(rs480).  Note that the card doesn't
>     like dynclk turned on.
> 
>     Signed-off-by: Johan Henriksson <jhn98032@gmail.com>
>     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Cc: "Antonino A. Daplas" <adaplas@pol.net>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 e553664a656ee329152789818b5b071a36ac1e45 0a698ad7daa8cdfd9eb5304812845306c9feb2f9 M      drivers
> 
> I turned dynclk off, no result (although dynclk is preferred).
> 
> What is interesting, is that the driver ignores "vga=normal" and "jumps" to
> a quite high res (I think is 1024x768 or something; the fonts look really nice
> though :)).

  Something strange is going on here: after I cleaned up the bisect kernels,
  I booted 2.6.23-rc7 using something like:
  "vga=normal nohz=on root=/dev/sda7 libata.noacpi=0 pci=assing-busses"
  and explicitly selecting "Enable Video Mode Handling Helpers" (which normally
  gets automatically selected once I choose "ATI Radeon display support" but I
  - suffering from intense paranoia - selected it by hand prior to selecting ATI
  Radeon ...).

  I works! X is no longer acting weird. I can't use "vga=791" anymore (the screen
  goes blank until X loads => timings definitely changed) but it *works* and I don't
  know why _and_ I can't seem to be able to make it go back to being bad :)
  
  I did a diff between the .config used in bisect and the current .config. I don't
  see anything suspicious.

  I'll to do a full cleanup and start all over. I'm going to nail this thing down if
  it's the last thing I do! (so help me God) :)

-- 
Mihai Donțu
