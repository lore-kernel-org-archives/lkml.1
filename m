Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZCZQ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZCZQ6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZCZQ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:58:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44169 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbZCZQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B1c9GJFjybgmQmtZtLJm+1EY7+KL3DTU4DQugqETlNISfaUAM7Zi8ANSTHWm2oGmN9
         oPLizxhvfx+3hBPWBifqO7pTjjhvmzFivLjEMPw9Bq+/vHWUsCKAbZA2Ot51jjpHJxRS
         lYEjIVQ59/nocYUrgavGFGh/h7FPhHH9d8UJI=
MIME-Version: 1.0
In-Reply-To: <4e5e476b0903260847m1de3e976ne20279df359176cf@mail.gmail.com>
References: <4e5e476b0903260847m1de3e976ne20279df359176cf@mail.gmail.com>
Date: Thu, 26 Mar 2009 16:58:36 +0000
Message-ID: <9b2b86520903260958r790e5459r553308311522e88f@mail.gmail.com>
Subject: Re: "ACPI: EC: missing confirmations, switch off interrupt mode" 
	wastes time on startup
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/09, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> Hi,
> I found that on my netbook (acer aspire one 110), kernel boot time
> (kernel 2.6.29) is severely affected by the EC boot procedure, since
> it is first fooled by a spurious interrupt in thinking that interrupts
> work, and then gets a timeout waiting for an interrupt that never
> arrives:
> [    0.351161] calling  acpi_init+0x0/0x236 @ 1
> [    0.361052] ACPI: EC: Look up EC in DSDT
> [    0.367754] ACPI: BIOS _OSI(Linux) query ignored
> [    0.368984] ACPI: EC: non-query interrupt received, switching to
> interrupt mode
> [    0.860013] ACPI: EC: missing confirmations, switch off interrupt mode.
> [    0.866062] ACPI: Interpreter enabled
>
> There is a bug report for this issue
> http://bugzilla.kernel.org/show_bug.cgi?id=12001 ,  marked as fixed on
> an old kernel, but I'm still getting it with 2.6.29 (maybe my
> controller is flaky?), so I'm looking for a workaround: is there a way
> to force the ACPI using polling?

[CC linux-acpi]

Thanks for reporting this bug / issue.  Your hardware is probably
defective by design - that is, it doesn't follow the ACPI spec.  But
we can't blame users for that :-).

I take it this isn't a regression, i.e. if you've tried earlier
kernels, it's never worked any better?

You say this is a severe delay - but your logs show 0.5 seconds only,
is that right?  Just to get it clear.

Currently there is no option to force polling, sorry.  I'm _guessing_
this was a deliberate omission.  But I can sympathise that even 0.5s
boot delay is bad on a netbook.

Feel free to create a new bugzilla entry.  You can attach the full
output of dmesg, but acpidump is probably not required.  What would be
really helpful is if you could file on bugzilla, and attach a full
debug trace.  I.e. as well as the normal dmesg, attach the dmesg
output after recompiling with this change:

drivers/acpi/ec.c:
29: /* Uncomment next line to get verbose printout */
30: /* #define DEBUG */

change to

30: #define DEBUG

Thanks again
Alan
