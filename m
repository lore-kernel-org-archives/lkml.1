Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbZENQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbZENQVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761222AbZENQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:20:28 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:44396 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760833AbZENQUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:20:25 -0400
Date: Thu, 14 May 2009 12:20:22 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86/acpi: calling mp_config_acpi_gsi in
 mp_register_gsi -v2
In-reply-to: <4A01C387.7090103@kernel.org>
Message-id: <alpine.LFD.2.00.0905141154390.19537@localhost.localdomain>
References: <4A01C35C.7060207@kernel.org> <4A01C387.7090103@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mp_config_acpi_gsi() has been dead code since the day it went into 2.6.27.
Rather than repairing that, I'd rather see it removed.

The justification for 2944e16b25e7fb8b5ee0dd9dc7197a0f9e523cfd
"x86: update mptable" was:

    1. kexec kernel with acpi=off
    2. work around BIOSes where acpi routing is working, but mptable is
       not right, so can use kernel/kexec to start other OSes that don't have
       good acpi support.
    
    command line: update_mptable

So this is a command line option to allow
MPS code to call into ACPI code to support kexec from an ACPI
mode into non-ACPI mode -- all without a single comment in the code.

I'm not convinced that the scenario that this code was
intended to address justifies adding unreadable code to
an area of the kernel which is notoriously over-complicated
and fragile.  Doing so is the opposite of optimizing for maintenance.

No, I don't want to see any MPS code ever call into ACPI code.

thanks,
Len Brown, Intel Open Source Technology Center
