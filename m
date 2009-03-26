Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbZCZPrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbZCZPrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbZCZPrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:47:25 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:61617 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962AbZCZPrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=d086Nhgvmp2+xJVZ6DerBhF4npPtfNq/utIqeOZggoafLkP2qVR9SN1HTeJa+l64rj
         jQ4+rg8eNbRqCpENAyM+p9J1EL4CM7N56/PI2MNhXqmBpvFtDDlqJuHe932g36cxDGLN
         hc2miz2OldigA+Uou3cfepInckKKsPIf6pGGM=
MIME-Version: 1.0
Date: Thu, 26 Mar 2009 16:47:20 +0100
Message-ID: <4e5e476b0903260847m1de3e976ne20279df359176cf@mail.gmail.com>
Subject: "ACPI: EC: missing confirmations, switch off interrupt mode" wastes 
	time on startup
From: Corrado Zoccolo <czoccolo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I found that on my netbook (acer aspire one 110), kernel boot time
(kernel 2.6.29) is severely affected by the EC boot procedure, since
it is first fooled by a spurious interrupt in thinking that interrupts
work, and then gets a timeout waiting for an interrupt that never
arrives:
[    0.351161] calling  acpi_init+0x0/0x236 @ 1
[    0.361052] ACPI: EC: Look up EC in DSDT
[    0.367754] ACPI: BIOS _OSI(Linux) query ignored
[    0.368984] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.860013] ACPI: EC: missing confirmations, switch off interrupt mode.
[    0.866062] ACPI: Interpreter enabled

There is a bug report for this issue
http://bugzilla.kernel.org/show_bug.cgi?id=12001 ,  marked as fixed on
an old kernel, but I'm still getting it with 2.6.29 (maybe my
controller is flaky?), so I'm looking for a workaround: is there a way
to force the ACPI using polling?

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
