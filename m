Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYFYCfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYFYCfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 22:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbYFYCfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 22:35:00 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:48487 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYFYCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 22:34:59 -0400
Date: Tue, 24 Jun 2008 22:34:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: add standard linux WARN() output to ACPI warnings
In-reply-to: <20080620142224.GF8135@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Message-id: <alpine.LFD.1.10.0806242231120.3014@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080620095247.GA24557@elte.hu>
 <20080620135639.GA5073@damson.getinternet.no> <20080620142224.GF8135@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
---
> i have hit this warning for the first time in January 2008:
...
> that's why WARN_ON()s are so important - there's no way my automated 
> tools (or even i, when taking a casual look at the logs) could have 
> picked up that new ACPI Exception - if each subsystem has different 
> warnings (which change frequently) then it's sheer impossible to 
> automate the answer to the "does that log show any anomaly" question. 

Maybe something like this would help?
(totally untested)

-Len

diff --git a/drivers/acpi/utilities/utmisc.c b/drivers/acpi/utilities/utmisc.c
index 1f057b7..d53e82c 100644
--- a/drivers/acpi/utilities/utmisc.c
+++ b/drivers/acpi/utilities/utmisc.c
@@ -1028,6 +1028,7 @@ acpi_ut_error(char *module_name, u32 line_number, char *format, ...)
 {
 	va_list args;
 
+	warn_on_slowpath(module_name, line_number);
 	acpi_os_printf("ACPI Error (%s-%04d): ", module_name, line_number);
 
 	va_start(args, format);
@@ -1042,6 +1043,7 @@ acpi_ut_exception(char *module_name,
 {
 	va_list args;
 
+	warn_on_slowpath(module_name, line_number);
 	acpi_os_printf("ACPI Exception (%s-%04d): %s, ", module_name,
 		       line_number, acpi_format_exception(status));
 
@@ -1058,6 +1060,7 @@ acpi_ut_warning(char *module_name, u32 line_number, char *format, ...)
 {
 	va_list args;
 
+	warn_on_slowpath(module_name, line_number);
 	acpi_os_printf("ACPI Warning (%s-%04d): ", module_name, line_number);
 
 	va_start(args, format);
