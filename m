Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbYKZR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbYKZR7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYKZR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:59:11 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:60200 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYKZR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gH3unZhHWz2bvarfB4yZlQ8ql9KAXRYQxEMMPfgAfKtamYEfuOO+NAmdUECKJoXf6W
         y4m0uNXg9XgtprHargT2NktbtpV0mdKM7DXkCmPPzUGl10D6X3rxiCIc4MR/G9UuOxjg
         qYXiV+YBtMeAaFaMJ7uu97YNT9kT/H1vwzlg0=
Message-ID: <9b2b86520811260959u633903f5o570a97ea83369f7c@mail.gmail.com>
Date: Wed, 26 Nov 2008 17:59:07 +0000
From: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Document sysfs interface to RTC system wakeup
Cc: "kernel list" <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20081126161524.GD1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081126161524.GD1983@elf.ucw.cz>
X-Google-Sender-Auth: eac14a78932fe86e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/08, Pavel Machek <pavel@suse.cz> wrote:
> diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
> index 8deffcd..ac843ab 100644
> --- a/Documentation/rtc.txt
> +++ b/Documentation/rtc.txt
> @@ -187,6 +187,88 @@ driver returns ENOIOCTLCMD.  Some common
>
>  If all else fails, check out the rtc-test.c driver!
>
> +	    Even newer /sys interface
> +	    ~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +tino.keitel@gmx.de
> +

It's unclear what the purpose of this email address is :).

<snip>

> +cd /proc/acpi
> +echo EXP0 > wakeup
> +echo PCI1 > wakeup
> +echo USB0 > wakeup
> +echo USB1 > wakeup
> +echo USB2 > wakeup
> +echo USB7 > wakeup
> +echo HDEF > wakeup

Can you add a comment before this block, something like

# Toggle example wakeup devices
# "cat wakeup" will show the list of devices on your specific system,
and their current state

There are two points here

1) This part of the example depends on the exact system.  AFAIK the
BIOS is free to call the devices whatever it likes.

2) These commands *toggle* the enabled state of the relevant wakeup
device.  If you naively wrote a script based on this example, it
_might_ work once.  It would probably fail the second time, because it
would disable all the devices again.


For added fun, my desktop systems, has a group of wakeup devices which
toggle as a single unit.  There are six devices in the group,
PEX[0-5].  If you do

for i in 0 1 2 3 4 5; do echo PEX$i > wakeup; done

the group toggles 6 times -so the state at the end will be the same as
the start!  Hopefully readers will read the values back after applying
them anyway, so they will notice if anything similarly strange
happens.

Alan
