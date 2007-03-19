Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbXCSTR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbXCSTR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXCSTR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:17:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:15744 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXCSTR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nJ9anGlyQFLckYMZ0qOTA+6dhQPLZtIuu3TqDctYQPdcyFO9EfrATBvQhFabJy8aPFeW+r9k7MNt4boNjfn8zF+3mKXrhaY5eqfepaEsMWdV9wmGIj+RgU5+ZPawNpGUiUQoV0jTHDhh2UxSPDyxCNOdQUb+++nKJ6AN5F3F5a8=
Message-ID: <b93822910703191217g6dcfbc9enc4a56aff176fb370@mail.gmail.com>
Date: Mon, 19 Mar 2007 20:17:56 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: tglx@linutronix.de
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, johnstul@us.ibm.com
In-Reply-To: <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (Bugzilla)
> Does booting w/ clocksource=acpi_pm avoid the problem?
No, it doesn't.
I hope it's ok that I added your email to CC.


2007/3/19, Stefan Prechtel <stefan.prechtel@googlemail.com>:
> Hi!
>
> If the ac-cable is plugged in, I can start my Notebook (HP nx6325)
> without any problems.
> On battery the kernel hanging around and it takes "hours" to boot the
> kernel and the system is *very* slow. For example an init-skript takes
> very long until it's started.
>
> I did a git-bisect and found out that this is the first bad commit:
> commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Feb 16 01:28:04 2007 -0800
>
>     [PATCH] clockevents: i386 drivers
>
>     Add clockevent drivers for i386: lapic (local) and PIT/HPET
> (global).  Update
>     the timer IRQ to call into the PIT/HPET driver's event handler and the
>     lapic-timer IRQ to call into the lapic clockevent driver.  The
> assignement of
>     timer functionality is delegated to the core framework code and replaces the
>     compile and runtime evalution in do_timer_interrupt_hook()
>
>     Use the clockevents broadcast support and implement the lapic_broadcast
>     function for ACPI.
>
>     No changes to existing functionality.
>
> So I tried to boot with nolapic on battery and with this option the
> kernel (and system) starts as it should.
> If you need more information, I will send it to you.
>
> Regards,
> Stefan Prechtel
>
