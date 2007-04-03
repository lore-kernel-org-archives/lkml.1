Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbXDCFvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbXDCFvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbXDCFvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:51:54 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:2855 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbXDCFvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:51:53 -0400
Date: Tue, 3 Apr 2007 07:49:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dave Jones <davej@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: Could the k8temp driver be interfering with ACPI?
Message-Id: <20070403074938.bc222b7e.khali@linux-fr.org>
In-Reply-To: <20070402192209.GB15810@redhat.com>
References: <45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070302114023.GD2163@elf.ucw.cz>
	<20070302114747.GB1212@srcf.ucam.org>
	<20070302135810.GF2156@elf.ucw.cz>
	<20070302220052.f93f3976.khali@linux-fr.org>
	<20070401153951.GE5095@ucw.cz>
	<20070402174859.80b74b05.khali@linux-fr.org>
	<20070402192209.GB15810@redhat.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Mon, 2 Apr 2007 15:22:09 -0400, Dave Jones wrote:
> On Mon, Apr 02, 2007 at 05:48:59PM +0200, Jean Delvare wrote:
>  > +	u8  val;
>  > +#ifdef CONFIG_ACPI
>  > +	acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
>  > +#endif
>  >  	outb(reg, data->addr + ADDR_REG_OFFSET);
>  > -	return inb(data->addr + DATA_REG_OFFSET);
>  > +	val = inb(data->addr + DATA_REG_OFFSET);
>  > +#ifdef CONFIG_ACPI
>  > +	acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
>  > +#endif
>  > +	return val;
>  > ... deletia, more of the same.
> 
> it'd probably end up a lot cleaner to #define them to empty macros
> in the !ACPI case in acpi/acpi.h and just #include it unconditionally.

Sure, the implementation details can be refined later. I'm only trying
to see what can be done for now.

-- 
Jean Delvare
