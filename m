Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZAWSY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZAWSY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZAWSYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:24:49 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:35958 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZAWSYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:24:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DiOV85ri0+xOzlLnczePaX8rZ7RzWhJ4xwZk4am9iD/SQSkOIVV/sMhtOVN08jfj5h
         2A3/23h9EsX10nHBD4L4XkJ/Qe5mveyfVxoamtgYfcs2lcpygWMmjbIoEyvYIW92EJfu
         LZKv62oMbpPfTKibHIZc48ClKs19SvMh87lyg=
MIME-Version: 1.0
In-Reply-To: <497A0164.90409@walrond.org>
References: <497A0164.90409@walrond.org>
Date: Fri, 23 Jan 2009 13:24:46 -0500
X-Google-Sender-Auth: ea70c43067b9a426
Message-ID: <3bd6b93c0901231024p3538ba04of40c2221db87b523@mail.gmail.com>
Subject: Re: serial8250 madness
From: Bruce Ashfield <bruce.ashfield@windriver.com>
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 12:41 PM, Andrew Walrond <andrew@walrond.org> wrote:
> Is anyone active in the serial code?
>

Definitely. Collectively, I see boards from 4 major archs
boot and use a serial console on a daily basis. Including
a pretty decent set of x86 boards.

> I thought I would make some in-house servers send output via ttyS0 from
> grub, kernel boot and console, like our rented remote servers do. I set it
> all up and basically nothing worked properly, so I started investigating
> with a null modem cable, setserial and cu to see what was happening.
>
> Machine A
>
> ttyS0 works fine. Can get grub output, kernel boot and console via ttyS0 as
> I wanted.
> ttyS1 doesn't work at all. It's detected, enabled in the bios etc etc but
> just doesn't work at all.

Interesting. In the past the BIOS has normally given us
problems when trying to get grub to output via serial,
first contact often appears once the kernel is booting.

>
> Machine B
>
> ttyS0 and ttyS1 will both receive, but neither will send. Go figure. Tested
> using a null modem cable, setserial and cu against the known good machine
> above.
>
> Machine C
>
> Grub and kernel outputs fine during boot, right up til the serial8250 output
> appears in the kernel log, at which point it then prints 'LSR safety check
> engaged' and reboots.
> Tried again without the console=ttyS0,57600 kernel parameter and it boots OK
> but starts printing the 'LSR...' message again as soon as agetty tries to
> attach to ttyS0. Doesn't reboot though...

Haven't witnessed B or C, but have had plenty of flow control
problems with infrastructure that prevented serial from properly
displaying.

I've also seen a few minor issues in the kernel itself, but it's
normally some slightly different chip and/or polling mode changes
interfering with normal operation. None of which seem useful
here.

>
> The Machines are all amd64, various motherboards, identical distros using
> 2.6.28.1 kernel.
> Either I have a particularly motley collection of kit, or the serial code is
> in a pretty bad way.
>
> I can provide further info/testing if anyone is active/interested.

I'm not much help, but I thought some extra data
points *might* be of use.

Bruce

>
> Andrew Walrond
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
"Thou shalt not follow the NULL pointer, for chaos and madness await
thee at its end"
