Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZJWQ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZJWQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZJWQ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:57:14 -0400
Received: from claw.goop.org ([74.207.240.146]:59474 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbZJWQ5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:57:11 -0400
Message-ID: <4AE1E06B.7010101@goop.org>
Date: Fri, 23 Oct 2009 09:57:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Erwan Velu <erwanaliasr1@gmail.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
       Ingo Molnar <mingo@redhat.com>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI table
 is present
References: <4AE178AF.3010804@gmail.com>
In-Reply-To: <4AE178AF.3010804@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/09 02:34, Erwan Velu wrote:
> When running the Linux Kernel, on some systems that doesn't have any
> DMI table (like a Xen domU), some dmi_* calls can generates Warnings
> like :
>
>> / WARNING: at /usr/src/linux-2.6.29.1/drivers/firmware/dmi_scan.c:425/
>> / dmi_matches+0x7e/0x80()/
>> / dmi check: not initialized yet/
>
> Some users reported this error :
> http://lists.xensource.com/archives/html/xen-users/2009-04/msg00128.html
> https://qa.mandriva.com/show_bug.cgi?id=54775

I don't think either of those reports are for kernels with upstream Xen
support.  Novell reimplements their own Xen support in their kernels; I
don't know whether Mandriva repackages the Novell kernel or not, but
some distros do.

> When the kernel is compiled with CONFIG_DMI, dmi_check_system(),
> dmi_first_match(), dmi_name_in_vendors(), dmi_find_device(),
> dmi_get_date(), dmi_match() calls doesn't check the status of the
> dmi_available variable.
>
> When this functions are called and if no valid dmi table has been
> found, this pretty simple patch just return the default values
> returned when CONFIG_DMI isn't set.
>
> This patch applies to the lastest git tree.
> I'm CCing the x86 maintainers as I can't find any maintainer of
> drivers/firmware/dmi.

This doesn't make any sense to me.  dmi_scan_machine() should be called
in the normal place under Xen, so it will initialize the DMI subsystem. 
There won't be any DMI table in domU, but that's OK.

Please include a full boot log showing the problem. "DMI not present or
invalid" should always be present in the kernel log.

    J
