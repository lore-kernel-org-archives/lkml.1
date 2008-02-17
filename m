Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYBQFor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYBQFor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYBQFoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:44:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbYBQFog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:44:36 -0500
Date: Sat, 16 Feb 2008 21:44:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com,
       linux-acpi@vger.kernel.org,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Message-Id: <20080216214410.b9699910.akpm@linux-foundation.org>
In-Reply-To: <20080216211603.bb4f3582.randy.dunlap@oracle.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216211603.bb4f3582.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 21:16:03 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
> ACPI is enabled, but DMI=n.
> 
> linux-2.6.25-rc2-mm1/drivers/acpi/thermal.c: In function 'acpi_thermal_init':
> linux-2.6.25-rc2-mm1/drivers/acpi/thermal.c:1792: error: 'thermal_dmi_table' undeclared (first use in this function)
> linux-2.6.25-rc2-mm1/drivers/acpi/thermal.c:1792: error: (Each undeclared identifier is reported only once
> linux-2.6.25-rc2-mm1/drivers/acpi/thermal.c:1792: error: for each function it appears in.)
> make[3]: *** [drivers/acpi/thermal.o] Error 1
> 

Bustage in x86-configurable-dmi-scanning-code.patch.  Previously, DMI=y was
just hardwired.  Now, it becomes selectable and stuff breaks.

I guess the DMI=n version of dmi_check_system() could become a macro so we
don't emit a reference to its argument, but that might generate
unused-variable warnings elsewhere.

