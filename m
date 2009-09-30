Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZI3HsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZI3HsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 03:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZI3HsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 03:48:13 -0400
Received: from p3plsmtpa01-09.prod.phx3.secureserver.net ([72.167.82.89]:44942
	"HELO p3plsmtpa01-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752809AbZI3HsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 03:48:12 -0400
Date: Wed, 30 Sep 2009 20:46:50 +1300
From: Kelly Bowa <kbpm@tuxedu.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: __pm_runtime_idle() returns -11!
Message-ID: <20090930074650.GA2300@box.home>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Alan Stern <stern@rowland.harvard.edu>,
	Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
	Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Mundt <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I get the following error messages in dmesg:

[    0.488758] ACPI: Enumerating devices from [\]
[    0.489673] PM: Adding info for acpi:LNXSYSTM:00
[    0.489856] acpi LNXSYSTM:00: __pm_runtime_idle()!
[    0.489862] acpi LNXSYSTM:00: __pm_runtime_idle() returns -11!
[    0.490952] PM: Adding info for acpi:LNXCPU:00
[    0.491154] acpi LNXCPU:00: __pm_runtime_idle()!
[    0.491161] acpi LNXCPU:00: __pm_runtime_idle() returns -11!
....

full dmesg: www.tuxedu.org/kbpm/dmesg2.txt

__pm_runtime_idle() returns -11 which could be that it is waiting for other 
suspend running in parallel or that pm_runtime_cancel() fails to suspend the 
given device ?.. this causes a noticeable delay in boot time. I get this on 
2.6.31-mm1 and ill soon test against 2.6.32-rc1..

-- 
kbpm
