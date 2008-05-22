Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYEVT4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYEVT4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYEVT4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:56:19 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:29556 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753028AbYEVT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:56:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TH1hphLD1tF10ffgharS4Jw+Lm0dhKyC5+RntRTJ/p3yhfkxLi9BTg+evYWxKtr7NYPtzIxEVdC9uTK3lQIU1TpUg756fuYyqSOJkFULXYe+IIalhDb30fhHqSxAb/gBSU9JuDHuKaPvllBEjlRhN5PwP78J0WvDtEdeq1kyvmE=  ;
X-YMail-OSG: 3GUzSKwVM1n141teZQ1L0Alv4nuPUfiS8pRn5iLy6tyLR.dat9OtVf2jtj8qiG_TpGRweJZCEOgvJTR9LLyv8wC5oZcWxouXKaQHvnpsvCEQvOK2QuRDgaH.vZNoPEfAyXE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stas Sergeev <stsp@aknet.ru>
Subject: Re: [patch] provide rtc_cmos platform device
Date: Thu, 22 May 2008 12:56:14 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <483317B4.7060601@aknet.ru> <20080521153223.e989cb88.akpm@linux-foundation.org> <4835C3DE.8070209@aknet.ru>
In-Reply-To: <4835C3DE.8070209@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221256.14346.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008, Stas Sergeev wrote:
> David Brownell wrote:
> > Well, "regression" is the wrong phrase. You've switched
> > drivers (from the legacy RTC to the new one), so this is
> > not the thing which worked for you before.
> > 
> I am not sure how could that happen.
> I am always just taking an old kernel
> config and never change the options
> that are not supposed to be changed.
> Was the old RTC driver removed by any
> chance?

The Kconfig was changed to prevent anyone from using
a particular broken configuration:  using legacy RTC
drivers along with the new RTC framework.

Presumably your old config was broken in that way.
So I can see why it'd feel like a regression.


> >> This may also help running the
> >> PNP-enabled kernel on an older PCs.
> > 
> > As in, pre-PNP. That's pretty darn old!
> 
> But... I think they should still be
> supported, unless it is too difficult.

Sure.  Having working hardware to test with is the
usual trouble here.  Do you have such hardware?

(I didn't object to fixing that, at all; I was just
pointing out that hardware where this matters is not
particularly available any more, and hasn't been so
for quite a few years now.)

 
> > (1) On an ARM build (with no PNP configured):
> 
> OK, but unfortunately I can't help
> with that. I won't touch any non-x86
> arch code, so I'll simply go for
> the #ifdef here, or someone else
> should make the patch instead. :)

Sure you can help; that's why I sent the compiler
messages telling what went wrong.  You were
referencing symbols that are not defined on
non-pnp systems.  All you have to do is provide
enough definitions to compile.  For test builds
you can even #undef the CONFIG_PNP* symbols at
the top of the rtc-cmos code.

I understand Russell King has been sitting on a
similar patch (for the generic bits, not the x86
specific parts) for some time.  Maybe you can get
his patch, which will surely work on ARM.

- Dave


> > You shouldn't define those symbols; the right values are already
> > defined in <asm/mc146818rtc.h>. RTC_PORT(0) and RTC_PORT(1) are
> > the symbolss to use; RTC_IRQ is already defined. All this stuff
> > is used in the <asm-generic/rtc.h> code ...
> 
> OK, thanks.
> I'll update the patch, in todo for
> the week-end.
> 



