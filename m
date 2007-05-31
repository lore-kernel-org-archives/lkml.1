Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbXEaQcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbXEaQcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbXEaQcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:32:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:21185 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbXEaQcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qcELvE+SZgQk4Buud3u6s8EqGu8RgWRVyGf6qeVWyztadYWlxJoLU5Gu2GtHLtinANGQXIuHQnf9OC3gZJ1ShhCcM8BLf8Ia4LRw9+W+E68vIw8gzsjQY0glAlYIExvxA7PbWmSfDwbQpHyH9nXOZkNNnWxx19qNtG26bBqZTcQ=
Message-ID: <86802c440705310932x3c85d9eao109fcf6445bd5938@mail.gmail.com>
Date: Thu, 31 May 2007 09:32:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705310917.19205.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705291844.00308.yinghai.lu@sun.com>
	 <86802c440705302136h1f2da2d8j881e062dfa6b7d7a@mail.gmail.com>
	 <20070530214859.ec026ac8.akpm@linux-foundation.org>
	 <200705310917.19205.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wednesday 30 May 2007 10:48:59 pm Andrew Morton wrote:
> > You could require that the architecture implement some specific function
> > for mapping the early-uart.
>
> We could, but we already have bt_ioremap, dmi_ioremap, and early_ioremap.
> Do we really want to proliferate more flavors of "early ioremap"?  I'd
> rather consolidate the ones we already have.
>
not really.

dhcp-umpk12-63-201:/home/yhlu/xx/xx/kernel/linux-2.6/include # grep
bt_ioremap * -r
asm-i386/dmi.h:#define dmi_ioremap bt_ioremap
asm-i386/io.h: * bt_ioremap() and bt_iounmap() are for temporary early boot-time
asm-i386/io.h:extern void *bt_ioremap(unsigned long offset, unsigned long size);
asm-i386/io.h:#define dmi_ioremap bt_ioremap

dhcp-umpk12-63-201:/home/yhlu/xx/xx/kernel/linux-2.6/include # grep
early_ioremap * -r
asm-x86_64/dmi.h:#define dmi_ioremap early_ioremap
asm-x86_64/io.h:extern void *early_ioremap(unsigned long addr,
unsigned long size);

dhcp-umpk12-63-201:/home/yhlu/xx/xx/kernel/linux-2.6/include # grep
dmi_ioremap * -r
asm-i386/dmi.h:#define dmi_ioremap bt_ioremap
asm-i386/io.h:#define dmi_ioremap bt_ioremap
asm-ia64/io.h:#define dmi_ioremap ioremap
asm-x86_64/dmi.h:extern void *dmi_ioremap(unsigned long addr, unsigned
long size);
asm-x86_64/dmi.h:#define dmi_ioremap early_ioremap

YH
