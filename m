Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbXC3SMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbXC3SMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXC3SMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:12:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:59328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbXC3SME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:12:04 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: 2.6.21-rc5-mm2 -- ACPI problems (lid switch broken, always shows running from AC, plugging in AC hangs machine)
Date: Fri, 30 Mar 2007 14:10:43 -0400
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com> <a44ae5cd0703291335q1eff6661hf398dfca1db8e491@mail.gmail.com> <a44ae5cd0703291449p1e8f75a2i68e9874362cef061@mail.gmail.com>
In-Reply-To: <a44ae5cd0703291449p1e8f75a2i68e9874362cef061@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703301410.43857.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 17:49, Miles Lane wrote:
> Hmm.   I've reproduced these problems with vanilla 2.6.21-rc5, so the
> latest acpi-git changes are off the hook....

I think the 1st message on this thread holds the answer:

> ACPI: BIOS bug: multiple APIC/MADT found, using 2
> ACPI: If "acpi_apic_instance=0" works better, notify linux-acpi@vger.kernel.org

Looking at your acpidump in
http://bugzilla.kernel.org/show_bug.cgi?id=8283
clearly the 2nd table is broken (it is missing the SCI override)
and that is why you get no ACPI interrupts.

If Windows works on your machine -- ACPI events such as power button etc --
then that is proof that Windows doesn't use the 2nd MADT and I need
to revert 09fe58356d148ff66901ddf639e725ca1a48a0af

thanks,
-Len
