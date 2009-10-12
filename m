Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbZJLPKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbZJLPKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbZJLPKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:10:11 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:40428 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbZJLPKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SJJIoWWCgI3P3WGyFWdqTqTCPjud/CTbAZ+RuyrWakhliYTnpYa8E7CmJ4AfYBZ5hZ
         1sA8EroeIdSz2D4e8rOxbmCFVRgirOoazByuxSltMs1J5G5vAeXl+wQS5SlVjnJSKyvm
         d3/7WGvQZMPfjT1CBmEvhfpjRX4McNcCv78dM=
MIME-Version: 1.0
In-Reply-To: <20091012150037.GA14004@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> 
	<20091012074221.GA19198@elte.hu> <8bd0f97a0910120605q17a586dag29cf4ab6d89dd29d@mail.gmail.com> 
	<20091012142940.GB1114@suse.de> <8bd0f97a0910120739k3122bctb46713881eaef9ca@mail.gmail.com> 
	<20091012150037.GA14004@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 12 Oct 2009 11:09:13 -0400
Message-ID: <8bd0f97a0910120809q7598d16sc285fbea9571536c@mail.gmail.com>
Subject: Re: [origin tree build failure] [PATCH] Revert "USB: musb: make 
	HAVE_CLK support optional"
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:00, Ingo Molnar wrote:
> * Mike Frysinger <vapier.adi@gmail.com> wrote:
>> On Mon, Oct 12, 2009 at 10:29, Greg KH wrote:
>> > On Mon, Oct 12, 2009 at 09:05:57AM -0400, Mike Frysinger wrote:
>> >> On Mon, Oct 12, 2009 at 03:42, Ingo Molnar wrote:
>> >> >
>> >> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> >> >
>> >> >> As usual, please test this for regressions, both new and old.
>> >> >
>> >> >>       USB: musb: make HAVE_CLK support optional
>> >> >
>> >> > This USB/Blackfin commit broke the x86 build with these config options:
>> >> >
>> >> >  CONFIG_USB_MUSB_HDRC=y
>> >> >  CONFIG_USB_MUSB_HOST=y
>> >> >  # CONFIG_USB_MUSB_PERIPHERAL is not set
>> >> >  # CONFIG_USB_MUSB_OTG is not set
>> >> >  # CONFIG_USB_GADGET_MUSB_HDRC is not set
>> >> >  CONFIG_USB_MUSB_HDRC_HCD=y
>> >> >  CONFIG_MUSB_PIO_ONLY=y
>> >> >  CONFIG_USB_MUSB_DEBUG=y
>> >> >
>> >> > Because a side-effect of the patch was that it enabled the driver on x86
>> >> > too which doesnt have HAVE_CLK. So this formerly embedded-only driver
>> >> > got exposed on the more widely tested x86 platform.
>> >>
>> >> this is dumb.  you're addressing unrealistic scenarios (randconfig) by
>> >> reverting code for realistic scenarios.  how about updating the
>> >> already present arch depend string instead.
>> >
>> > We want 'randconfig' to work, so this is not unrealistic.  Have you not
>> > seen Randy Dunlap's zillion patches to get this to all work properly
>> > over the past months?
>>
>> i'm not suggesting it not be fixed, i'm suggested it be *fixed*
>> instead of blindly reverted.
>
> Sure, i'd agree with that if we were in the merge window. The thing is,
> -rc4 is not the time to do patches that need fixes. It is to fix
> regressions. I dont think this commit applies as a regression fix, does
> it? It _introduces_ a regression.
>
> So a revert is a proper first-level response to this and i fail to
> understand your surprise about that. A fix is nice too, of course, if
> it's simple enough.

if the change were non-trivial and/or the person making the change
were unresponsive, then a revert would certainly make sense this late
in the game.  but neither really apply here.
-mike
