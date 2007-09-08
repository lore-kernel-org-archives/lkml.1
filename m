Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbXIHWw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbXIHWw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 18:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbXIHWwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 18:52:22 -0400
Received: from mail97.megamailservers.com ([216.251.36.97]:34083 "EHLO
	mail97.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbXIHWwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 18:52:21 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: broken ACPI NUMA config option
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sat, 08 Sep 2007 18:51:39 -0400
Message-Id: <1189291899.13467.20.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If I select X86_64_ACPI_NUMA, then ACPI_NUMA is (properly) selected
automatically, but ACPI is not selected automatically. This causes
ACPI_NUMA to not be built, and the kernel compile fails with unresolved
symbols.

Steps to reproduce:

	make clean
	make mrproper
	make noallconfig

	select SMP
	select NUMA
	select X86_64_ACPI_NUMA

	make
	<boom>

results:

	  LD      .tmp_vmlinux1
	drivers/built-in.o: In function `acpi_bus_generate_event':
	(.text+0x23365): undefined reference to `event_is_open'
	drivers/built-in.o: In function `acpi_bus_get_power':
	(.text+0x2361d): undefined reference to `acpi_power_get_inferred_state'
	drivers/built-in.o: In function `acpi_bus_set_power':
	(.text+0x23733): undefined reference to `acpi_power_transition'
	drivers/built-in.o: In function `acpi_bus_set_power':
	(.text+0x237a5): undefined reference to `acpi_power_transition'
	make: *** [.tmp_vmlinux1] Error 1

James
	/\V

