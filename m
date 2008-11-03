Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYKCVFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYKCVFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYKCVFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:05:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756254AbYKCVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:05:23 -0500
Date: Mon, 3 Nov 2008 13:05:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: marvin@mydatex.cz
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 11886] New: without serial console system
 doesn't poweroff
Message-Id: <20081103130505.d5b45f87.akpm@linux-foundation.org>
In-Reply-To: <bug-11886-10286@http.bugzilla.kernel.org/>
References: <bug-11886-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 29 Oct 2008 04:06:11 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11886
> 
>            Summary: without serial console system doesn't  poweroff
>            Product: Power Management
>            Version: 2.5
>      KernelVersion: 2.6.27.4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: power-management_other@kernel-bugs.osdl.org
>         ReportedBy: marvin@mydatex.cz
> 
> 
> Latest working kernel version:
> Earliest failing kernel version:2.6.27.2
> Distribution: Debian Etch
> Hardware Environment: Supermiro C2SBC-Q  Dual Core Intel Cpu 1G RAM
> Software Environment: Debian Etch
> Problem Description: If I does't add serial console to kernel command line
> system doesn't poweroff. Linux hangs there:
> 
> e1000e 0000:0d:00.0: PCI INT A disabled
> e1000e 0000:00:19.0: PCI INT A disabled
> ACPI: Preparing to enter system sleep state S5
> Disabling non-boot CPUs ...
> 
> If I disable in kernel config Suspend to Ram and Hibernate all works without
> console. But with Suspend and hibernate enabled and serial console  added to
> kernel cmd line all works too:
> 
> e1000e 0000:0d:00.0: PCI INT A disabled
> e1000e 0000:00:19.0: PCI INT A disabled
> ACPI: Preparing to enter system sleep state S5
> Disabling non-boot CPUs ...
> CPU 1 is now offline
> SMP alternatives: switching to UP code
> CPU1 is down
> Power down.
> acpi_power_off called
> 
> Steps to reproduce:
> Compile kernel with attached config and try poweroff without serial console.
> 

OK, this is weird.

But the good news is that there is a very small number of commits
between 2.6.27.2 and 2.6.27.4.

ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.27.3
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.27.4

I'd be looking at these:

commit 3b987ac961486373f91191b14291b331fa546072
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Sep 6 13:13:01 2008 +0200

    ACPI suspend: Always use the 32-bit waking vector
    
    commit a6629105dd03d370fcb31e97bddf223fa4bb651e upstream.


commit 66036f5862883fcc9f7ff8550685a5a3de1a57e4
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Oct 4 00:05:05 2008 +0200

    ACPI Suspend: Enable ACPI during resume if SCI_EN is not set
    
    commit d0c71fe7ebc180f1b7bc7da1d39a07fc19eec768 upstream.



presumably 2.6.28-rc3 is also broken?
