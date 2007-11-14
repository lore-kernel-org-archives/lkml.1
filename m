Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXKOI2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXKOI2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXKOI2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:28:09 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:47845 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753253AbXKOI2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:28:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uMvXmWcWO3h7XWffbCxXGp39wb2pbzsIz9e9fXqA4uqHEMY1a82N6eOrnPXxw+6Vw09bn1ody7ttQpVYOzK9m1P7rErxFMArconE1JNzui6P5knGI19hOPNPode5Xq/Uu3NfMHMiu1cpfx0N5vVpfG3xGWk8OmLcQs6wae4ts5Q=  ;
X-YMail-OSG: 21qZ0VIVM1kJxj7M27rPXVIDzgqPbFEdEo_jUkV3siSp6DxMYpaSYuucM81mi0SoAXN_CzHKzw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Thu, 15 Nov 2007 06:21:36 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711150017.29617.david-b@pacbell.net> <200711150619.27571.nickpiggin@yahoo.com.au>
In-Reply-To: <200711150619.27571.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711150621.37198.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 06:19, Nick Piggin wrote:
> On Thursday 15 November 2007 19:17, David Brownell wrote:
> > On Wednesday 14 November 2007, Nick Piggin wrote:
> > > > > > All this does is prevent constant and needless checking for
> > > > > > "do you want to preempt me now?" "now?" "now?" in "now?" the
> > > > > > middle "now?" of "now?" i/o "now?" loops.
> > > > >
> > > > > Actually that's wrong.
> > > >
> > > > Certainly it's right for the mainstream kernel.  Dropping a
> > > > lock (other than a raw spinlock) does that checking; when a
> > > > loop needs to acquire then drop such a lock, that's exactly
> > > > what's going on.
> > >
> > > Obviously a raw spinlock is no different from a regular
> > > spinlock upstream.
> >
> > Erm, no.  The raw ones don't have the extra logic when
> > the lock gets dropped.
>
> If you don't have preemption disabled already, then it is a
> bug to use raw spinlocks. If you do have preemption disabled,
> then a regular spinlock isn't going to check preemption after
> the unlock either.

And I might add that this is just trying to nitpick at a weak link
in the argument rather than prove anything important.

Even if you are avoiding preemption checks in upstream kernels,
this is probably like several instructions to do. So if you're
avoiding this for preformance reasons, then something's not right.
