Return-Path: <linux-kernel-owner+w=401wt.eu-S966028AbXCSRLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966028AbXCSRLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966031AbXCSRLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:11:03 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:31408 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966028AbXCSRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QiVR0TbYg9Anj4gEdeDN7nwcZInO0xX77hvUVlmvrQwawSVlhmP9SCK2cwbFx9x2gN22AuLcom2Vi1SJZfb+m4r/rpVUntoH61QBy9SjxauqvkJRGU0e6kx36irgTDSAvxjdTvb9VzD7RSYPplIDnu84i8n9CisSNmZFCayM03I=
Message-ID: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
Date: Mon, 19 Mar 2007 18:10:59 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Cc: tglx@linutronix.de, mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

If the ac-cable is plugged in, I can start my Notebook (HP nx6325)
without any problems.
On battery the kernel hanging around and it takes "hours" to boot the
kernel and the system is *very* slow. For example an init-skript takes
very long until it's started.

I did a git-bisect and found out that this is the first bad commit:
commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Feb 16 01:28:04 2007 -0800

    [PATCH] clockevents: i386 drivers

    Add clockevent drivers for i386: lapic (local) and PIT/HPET
(global).  Update
    the timer IRQ to call into the PIT/HPET driver's event handler and the
    lapic-timer IRQ to call into the lapic clockevent driver.  The
assignement of
    timer functionality is delegated to the core framework code and replaces the
    compile and runtime evalution in do_timer_interrupt_hook()

    Use the clockevents broadcast support and implement the lapic_broadcast
    function for ACPI.

    No changes to existing functionality.

So I tried to boot with nolapic on battery and with this option the
kernel (and system) starts as it should.
If you need more information, I will send it to you.

Regards,
Stefan Prechtel
