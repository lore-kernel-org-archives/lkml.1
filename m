Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXCRKaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXCRKaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbXCRKaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:30:00 -0400
Received: from saeurebad.de ([85.214.36.134]:43786 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190AbXCRK37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:29:59 -0400
Date: Sun, 18 Mar 2007 11:25:33 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org
Subject: ACPI initialization failure with v2.6.21-rc4
Message-ID: <20070318102532.GB27142@leiferikson>
Mail-Followup-To: linux-kernel@vger.kernel.org, lenb@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[resend due to wrong mail headers last time]

Hi,

The kernel version mentioned in the subject won't boot because the ACPI
system does not get initialized; the system freezes on an outb() in
acpi_os_write_port() i.e. it does not do anything anymore and just hangs.

Here is the `stack trace' I managed to extract via debugging output:

	-- acpi_os_write_port(0xb2, 240, 8)
	-- acpi_hw_set_mode(ACPI_SYS_MODE_ACPI)
	-- acpi_enable()
	-- acpi_enable_subsystem(~ACPI_NO_ACPI_ENABLE)
	-- acpi_early_init()
	...

Notes:
	* acpi_os_write_port(): I printk'd the arguments; the port
	  formatted with %#x and the value with %u.

	* acpi_enable_subsystem(): I removed ACPI_NO_HARDWARE_INIT
	  from the arguments because it is not used anymore.
	  In this context I want to mention that it probably can be
	  removed from include/acpi/actypes.h generally.

Random question:

	I noticed that acpi_gbl_FADT is declared in
	include/acpi/acglobal.h but where is it actually defined and
	initialized?

HTH,
Hannes
