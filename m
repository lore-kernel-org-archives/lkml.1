Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbXELRe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbXELRe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 13:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbXELRet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 13:34:49 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670AbXELRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 13:34:48 -0400
Date: Sat, 12 May 2007 10:34:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tear <tarrqt@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Dell Optiplex GX240, ACPI and APIC
Message-Id: <20070512103441.a21194fc.akpm@linux-foundation.org>
In-Reply-To: <229533.82694.qm@web63609.mail.re1.yahoo.com>
References: <229533.82694.qm@web63609.mail.re1.yahoo.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 07:04:25 -0700 (PDT) Tear <tarrqt@yahoo.com> wrote:

> Summary: If ACPI is not enabled but APIC is,
> then there is trouble on Dell Optiplex GX240.
> If both are enabled or if both are disabled, then
> everything is fine. The attached patch removes
> Dell Optiplex GX240 from the ACPI blacklist.
> 
> ---
> 
> Hello,
> 
> I have a Dell Optiplex GX240 and when I boot Linux, ACPI
> gets set up by only acpi=ht. dmesg shows the following line:
> 
>    DELL GX240 detected: force use of acpi=ht
> 
> Everything seemed to be fine. However, I discovered that
> everything is not fine. The USB controller works so slowly
> that copying a few (uncached) 1 megabyte large photos from
> a USB-enabled digital camera takes many minutes instead of
> a couple of seconds.
> 
> I am using Linux 2.6.21.1 on a Debian 4.0 ("Etch") system.
> 
> I thought that this might be related to ACPI. So I tried
> to boot with _only_ "acpi=force" appended to the kernel
> command line. Voila, the USB controller started to work
> at full speed and copying photos from my digital camera
> took only seconds.
> 
> I tested the system with "acpi=force" and could not find
> anything which did not work. So, can we please remove
> Dell Optiplex GX240 from the blacklist in
> 
> ..../arch/i386/kernel/acpi/boot.c
> 
> ? The attached patch does just that: It removes Dell
> Optiplex GX240 from the ACPI blacklist.
> 
> I thought that this might be related to interrupts and
> APIC as well. (Note that this is APIC, not ACPI.) I tried
> booting with _only_ "noapic" and "nolapic" appended to the
> command line. Again, the USB controller started to work
> at full speed.
> 
> If removing Dell Optiplex GX240 from the ACPI blacklist
> is not wanted/possible, then is there a way to disable
> APIC and LAPIC (note that this is APIC not ACPI) by
> default on Dell GX240 machines? (I.e. Can one patch
> the kernel so that APIC and LAPIC isn't used on
> these machines? - I know that I can use the noapic
> and nolapic options on the kernel command line.)
> 
> Thank you for your attention.
> 
> - Tear
> 
> Note: Please include me in CC of your replies.
> 
> 
> --- linux-2.6.21.1.orig/arch/i386/kernel/acpi/boot.c	2007-05-01 17:10:30.000000000 +0300
> +++ linux-2.6.21.1/arch/i386/kernel/acpi/boot.c	2007-05-01 20:31:53.000000000 +0300
> @@ -971,14 +971,6 @@
>  	 },
>  	{
>  	 .callback = force_acpi_ht,
> -	 .ident = "DELL GX240",
> -	 .matches = {
> -		     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Computer Corporation"),
> -		     DMI_MATCH(DMI_BOARD_NAME, "OptiPlex GX240"),
> -		     },
> -	 },
> -	{
> -	 .callback = force_acpi_ht,
>  	 .ident = "HP VISUALIZE NT Workstation",
>  	 .matches = {
>  		     DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
> 

Thanks.  Let's cc the acpi list.

The origin of that blacklist entry appears to be lost in the mists of time.
git-blame got tripped up by an intervening Lindent run and my gittiness
is insufficient for tracking changes before that.
