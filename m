Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbYDLFLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbYDLFLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbYDLFLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:11:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbYDLFLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:11:06 -0400
Date: Fri, 11 Apr 2008 22:11:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2 -- initcall acpi_init+0x0/0x216() returned with
 preemption imbalance
Message-Id: <20080411221102.dc2d8c7d.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0804111241n7e6cbcadx1d9f66ed32dece1a@mail.gmail.com>
References: <a44ae5cd0804111241n7e6cbcadx1d9f66ed32dece1a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 15:41:17 -0400 "Miles Lane" <miles.lane@gmail.com> wrote:

> Is this indicative of a kernel or hardware problem?
> 
> [    0.279606] ACPI: Using IOAPIC for interrupt routing
> [    0.279789] initcall acpi_init+0x0/0x216() returned with preemption imbalance
> [    0.330789] ACPI: PCI Root Bridge [PCI0] (0000:00)
> 

That's a software bug.  Something under acpi_init() has mismatched
preempt_disable/preempt_enable or mismatched spin_lock/spin_unlock, etc.

