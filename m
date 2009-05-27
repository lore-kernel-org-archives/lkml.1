Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbZE0RPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbZE0RPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZE0RPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:15:03 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:2638 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbZE0RPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:15:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vQqj9WyPQaOOj0Hvx8O0VQSPNsan40lCaHNlzmAthJH+bcF1tL/+/3DjOzd036IAbo
         tpL16oozCng5Vm1ezKjTq7IL8H0i+LSpZPWh0Ij+u+M/WajEIje9m/u4PLlkraOTIzvn
         ZDnB6lbQMjYGGxAZ4TXq5OD144BRMqWzshnYQ=
MIME-Version: 1.0
In-Reply-To: <20090416014230.4885.94926.sendpatchset@localhost.localdomain>
References: <20090416014230.4885.94926.sendpatchset@localhost.localdomain>
Date: Wed, 27 May 2009 10:15:02 -0700
Message-ID: <86802c440905271015l15d46ef8w64558e455120d2a9@mail.gmail.com>
Subject: Re: [PATCH] x86: print real IOAPIC version for x86-64
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 2:48 PM, Naga Chumbalkar
<nagananda.chumbalkar@hp.com> wrote:
> Fix the fact that the IOAPIC version number in the x86_64 code path always
> gets assigned to 0, instead of the correct value.
>
> Before the patch: (from "dmesg" output):
> ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23     <---
>
> After the patch:
> ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23    <---
>
> History:
> io_apic_get_version() was compiled out of the x86_64 code path in the commit
> f2c2cca3acef8b253a36381d9b469ad4fb08563a:
>
> *************************
> Author: Andi Kleen <ak@suse.de>
> Date:   Tue Sep 26 10:52:37 2006 +0200
>
>    [PATCH] Remove APIC version/cpu capability mpparse checking/printing
>
>    ACPI went to great trouble to get the APIC version and CPU capabilities
>    of different CPUs before passing them to the mpparser. But all
>    that data was used was to print it out.  Actually it even faked some data
>    based on the boot cpu, not on the actual CPU being booted.
>
>    Remove all this code because it's not needed.
>
>    Cc: len.brown@intel.com
>
>    Signed-off-by: Andi Kleen <ak@suse.de>
> *************************
>
> At the time, the IOAPIC version number was deliberately not printed in the
> x86_64 code path. However, after the x86 and x86_64 files were merged, the net
> result is that the IOAPIC version is printed incorrectly in the x86_64 code
> path.
>
> The patch below provides a fix. I have tested it with acpi, and with acpi=off,
> and did not see any problems.
>
> Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>
