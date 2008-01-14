Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbYANFbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbYANFbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 00:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYANFau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 00:30:50 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:50392 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYANFat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 00:30:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O6Piq8/dcv1YV2qVMlR62oJ0mNr3qUEoEnrP5vDT4dbkzrJbVeypd3tDVZGMAItIz+kd/D6/Os+JBeKj8xjXAXenfuuTlJh9gN0dWbLf5Pue//dlm3TZCoSWGD8CD2xXp+xZlCPv9NFl0SZ0w0RsNmsYKw8pk3OYQSYKcGmRisE=
Message-ID: <3e8340490801132130l737e166i3f957518170b98fc@mail.gmail.com>
Date: Mon, 14 Jan 2008 00:30:48 -0500
From: "Bryan Donlan" <bdonlan@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: Is it possible to change IRQ for certain device?
Cc: "Jan Marek" <linux@hazard.jcu.cz>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <75b66ecd0801131957s1e70bda9x342f16a7d16a2789@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080110110535.GA25706@hazard.jcu.cz>
	 <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com>
	 <20080111165711.GA21173@hazard.jcu.cz>
	 <75b66ecd0801131957s1e70bda9x342f16a7d16a2789@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 13, 2008 10:57 PM, Lee Revell <rlrevell@joe-job.com> wrote:
> On Jan 11, 2008 11:57 AM, Jan Marek <linux@hazard.jcu.cz> wrote:
> > I suppose, that VGA card does not need unique IRQ, but programmers,
> > which wrote driver, want it. I can imagine, that VGA card have many
> > interrupts, especially in the OpenGL games, but I cannot assign unique
> > IRQ for VGA card at all :-(
> >
> > But thank you for advice: I will try to send e-mail to Gigabyte and ask
> > they, if it possible to do change in the BIOS.
> >
> > BTW: it is interesting: I had a Biostar TA690G motherboard and it behave
> > similar as Gigabyte: I cannnot assign unique IRQ to the external
> > graphics card... Chipsets of this motherboards are the same...
> >
> > I've tried to solve this problem by bought of new motherboard: Gigabyte
> > MA790FX-DS5. I will see, if this board will behave as previous board...
>
> Why is a shared IRQ a problem for you?  IRQ handlers are supposed to
> be fast enough that disabling an IRQ line for the duration of the
> handler execution should not be a problem even if the IRQ is shared.
> VGA interrupts in particular should only fire once per frame and only
> need to flip some bits to wake up any processes waiting on vsync.
>
> If you have issues with a shared VGA interrupt then the bug is that
> some IRQ handler runs for too long and should be deferring work to a
> bottom half.

Jan is apparently using the nvidia binary driver, so I doubt it will
be possible to fix the bug that prevents it from sharing IRQs.
