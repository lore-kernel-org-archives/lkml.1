Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbXCDOxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbXCDOxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbXCDOxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:53:04 -0500
Received: from mxout-03.mxes.net ([216.86.168.178]:3881 "EHLO
	mxout-03.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbXCDOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:52:55 -0500
Message-ID: <35793.86.7.220.119.1173019974.squirrel@wmbeta.mxes.net>
In-Reply-To: <1172531359.7101.22.camel@daplas>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net> 
    <20070224030950.074f88d4.akpm@linux-foundation.org> 
    <33525.86.7.220.119.1172358010.squirrel@wmbeta.mxes.net> 
    <1172359843.4415.8.camel@daplas> 
    <34578.86.7.220.119.1172401665.squirrel@wmbeta.mxes.net> 
    <1172493697.20842.6.camel@daplas> 
    <36488.86.7.220.119.1172515738.squirrel@wmbeta.mxes.net>
    <1172531359.7101.22.camel@daplas>
Date: Sun, 4 Mar 2007 14:52:54 -0000 (GMT)
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
From: "Andrew Nelless" <andrew@nelless.net>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Reply-To: "Andrew Nelless" <andrew@nelless.net>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, February 26, 2007 11:09 pm, Antonino A. Daplas wrote:
>
> Not sure if the timer override workaround for nvidia chipsets is the
> culprit, but if you want, you can choose to revert that to the previous behavior (which is
> ignoring ACPI timer override). Open arch/x86_64/kernel/earlyquirk.c:nvidia_bugs() and change
> this line:
>
> if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) return; into this:
>
> acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check); /* return; */
>
>
> Tony
>

This fixes the problem. After a lot of rebooting
and testing the problem is definitely gone when this
check is patched out and the ACPI timer override is
ignored. It looks like there should be a cleaner
patch than just obliterating the condition and return
though.

Perhaps the code should remain as is and
"acpi_use_timer_override" could be complimented
by exposing the "acpi_skip_timer_override" option to
the kernel command line?

This seems to have been exposed in the past:
https://www.x86-64.org/pipermail/discuss/2005-April/005948.html

