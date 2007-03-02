Return-Path: <linux-kernel-owner+w=401wt.eu-S2992469AbXCBONM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992469AbXCBONM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992471AbXCBONM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:13:12 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4435 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992469AbXCBONK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:13:10 -0500
Date: Fri, 2 Mar 2007 15:10:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070302151055.d2665d66.khali@linux-fr.org>
In-Reply-To: <20070302114747.GB1212@srcf.ucam.org>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070302114023.GD2163@elf.ucw.cz>
	<20070302114747.GB1212@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Fri, 2 Mar 2007 11:47:47 +0000, Matthew Garrett wrote:
> The DSDT code clearly can't touch the hardware itself - hardware access 
> is carried out by the kernel. If we can identify cases where ACPI reads 
> and writes would touch resources claimed by other drivers, that would be 
> a good starting point for working out what's going on.

I'm not familiar with APCI at all so I didn't know, but what you write
here brings some hope. Would it be possible to parse all the DSDT code
at boot time and deduce all the ports which ACPI would need to request
to be safe? Or do we have to wait for the accesses to actually happen?

> Of course, this ignores the case where the DSDT just traps into SMM 
> code. That one is clearly unsolvable.

Yeah, SMM is an even more complex problem :(

Do we know in advance when we are going to SMM mode and back? If we do,
I'd be happy with a mutex every interested driver could use to protect
relevant parts of its code. SMBus master drivers for example could
request that mutex during SMBus transactions. Of course we don't know
if SMM will actually touch the SMBus, but better safe than sorry I
guess. And SMM calls aren't happening so frequently, are they?

Thanks,
-- 
Jean Delvare
