Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXLLEnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXLLEnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXLLEmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:42:50 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:2043 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751653AbXLLEmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IZV+6lt/RBO+82+0sz6UdWVQRGIUNxOmy8qB3J6zAlpP38kBd1bHXC01gUdbeRA8JkZ58CdHZ/wRXRXAOHv6AHdmLEC+w5Uqq66hdecn0d3ysdmNiQG0DtTckSjiQwjU2C3sYGr92iAObV7+TcYGZ/gK1PSn+9wD7uQX6GwhcB0=
Message-ID: <a8e1da0712112042w455caf55jab4f312dd356d57@mail.gmail.com>
Date: Wed, 12 Dec 2007 12:42:48 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] x86 boot : export boot_params via sysfs
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <20071211184012.a84fff36.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197391749.17188.8.camel@caritas-dev.intel.com>
	 <20071211184012.a84fff36.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 10:40 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 11 Dec 2007 16:49:09 +0000 "Huang, Ying" <ying.huang@intel.com> wrote:
>
> > This patch export the boot parameters via sysfs. This can be used for
> > debugging and kexec.
> >
> > The files added are as follow:
> >
> > /sys/kernel/boot_params/data  : binary file for struct boot_params
> > /sys/kernel/boot_params/version       : boot protocol version
>
> Your patch uses kobject_create_and_register() which was added in Greg's
> driver tree as of 2.6.24-rc4-mm1.
>
> However for some reason kobject_create_and_register() has magically vanished
> from Greg's current driver tree so I cannot carry this patch, sorry.

Seems kobject_create_and_register would be replaced by
kobject_create_and_add, and the uevent handling would be separated
from original create_and_register onefunction.

wait for greg's patches or modify to use:

kobject_init
kobject_add
kobject_uevent

BTW, I suspect whether the uevent is really needed for boot_params object.

Regards
dave
