Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYGVKUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYGVKUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYGVKTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:19:50 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:46700 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYGVKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mm/GLS1R7ETXWFrHNJ1tviiL1bjWIAgR/uWN3BIdHAtpF9WIO0X7/cxszG1i74/WJk
         NlG1mERCRjKGk6y56HufH2Yt5isRq/eGkoHkjgjMH4eW+CjX9s7OR+3DdZdTu7IABbBT
         4sW1ITLulIOVDXBZJ+FOy5p1hWv6ANY3Vyyfo=
Date: Tue, 22 Jul 2008 14:19:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [patch 1/5] x86: ACPI - add checking for NULL early param
Message-ID: <20080722101945.GA6699@lenovo>
References: <20080705115334.892720771@gmail.com> <486f61a9.2135440a.0d16.ffffbd7f@mx.google.com> <20080722025332.afddd49b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722025332.afddd49b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Tue, Jul 22, 2008 at 02:53:32AM -0700]
| On Sat, 05 Jul 2008 15:53:35 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| > 
| > Index: linux-2.6.git/drivers/acpi/tables.c
| > ====================================================================
| > --- linux-2.6.git.orig/drivers/acpi/tables.c	2008-01-21 23:14:47.000000000 +0300
| > +++ linux-2.6.git/drivers/acpi/tables.c	2008-07-05 12:24:16.000000000 +0400
| > @@ -300,6 +300,8 @@ int __init acpi_table_init(void)
| >  
| >  static int __init acpi_parse_apic_instance(char *str)
| >  {
| > +	if (!str)
| > +		return -EINVAL;
| >  
| >  	acpi_apic_instance = simple_strtoul(str, NULL, 0);
| >  
| 
| Could you please explain this patch?
| 

we could get NULL deref here - if you start kernel as

	qemu-system-x86_64 -kernel arch/x86/boot/bzImage -append "root=/dev/sda acpi_apic_instance" ../images/root-j

so user was not carried about correct boot option and the kernel respond by
hang - which is not good I think. Actually - by the patch we easy protect
ourself from user-madness :)

		- Cyrill -
