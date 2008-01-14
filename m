Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYANGE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYANGE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYANGEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:04:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:17088 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYANGEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:04:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AwNTPNqOKr75UL1gBs89ah6Vg4L2hI8PCMzY6QgZqDkn4m2Ggd1kM/KHwdJ5MAxhLV/RLK0BWCA4iao+v1NMXAKS7UFnuD4nCgKtG69ZoKv8P7B9gDpoRYxaTUl63tzQU4XQC/n7zA3u6ZyeAaMsXYSjc2ublMY39GOUzlyFH5s=
Message-ID: <75b66ecd0801132204r5d4a5401hacc1de871342cf8c@mail.gmail.com>
Date: Mon, 14 Jan 2008 01:04:19 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Bryan Donlan" <bdonlan@gmail.com>
Subject: Re: Is it possible to change IRQ for certain device?
Cc: "Jan Marek" <linux@hazard.jcu.cz>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <3e8340490801132130l737e166i3f957518170b98fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080110110535.GA25706@hazard.jcu.cz>
	 <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com>
	 <20080111165711.GA21173@hazard.jcu.cz>
	 <75b66ecd0801131957s1e70bda9x342f16a7d16a2789@mail.gmail.com>
	 <3e8340490801132130l737e166i3f957518170b98fc@mail.gmail.com>
X-Google-Sender-Auth: 9651a284c8c9e57d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 12:30 AM, Bryan Donlan <bdonlan@gmail.com> wrote:
>
> On Jan 13, 2008 10:57 PM, Lee Revell <rlrevell@joe-job.com> wrote:
> > On Jan 11, 2008 11:57 AM, Jan Marek <linux@hazard.jcu.cz> wrote:
> > Why is a shared IRQ a problem for you?  IRQ handlers are supposed to
> > be fast enough that disabling an IRQ line for the duration of the
> > handler execution should not be a problem even if the IRQ is shared.
> > VGA interrupts in particular should only fire once per frame and only
> > need to flip some bits to wake up any processes waiting on vsync.
> >
> > If you have issues with a shared VGA interrupt then the bug is that
> > some IRQ handler runs for too long and should be deferring work to a
> > bottom half.
>
> Jan is apparently using the nvidia binary driver, so I doubt it will
> be possible to fix the bug that prevents it from sharing IRQs.
>

Ah, of course, stupid me.  Thought I was on linux-audio-user where
this is a FAQ (for completely different reasons) and not LKML.

But this is strange - I'm sure I've seen people using that driver with
a shared IRQ before.

Jan, maybe you can blacklist ohci-hcd as a workaround?  In any case
let's take this discussion off LKML so as not to spam the list with
binary only driver issues.

Lee
