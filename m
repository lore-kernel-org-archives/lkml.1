Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYAQWD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYAQWD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbYAQWDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:03:51 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36488 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYAQWDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:03:50 -0500
Date: Thu, 17 Jan 2008 14:09:56 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86: copy srat table and unmap in acpi_parse_table
In-reply-to: <20080117204343.GA32175@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801171409.56611.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801171244.46228.yinghai.lu@sun.com>
 <20080117204343.GA32175@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008 12:43:43 pm Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > [PATCH] x86: copy srat table and unmap in acpi_parse_table
> > 
> > 
> > the old acpi_numa_slit_init was saving old address in early stage 
> > acpi_slit and acpi_parse_table can not unmap address that. the patch 
> > copy the slit in the callback, so we could unmap table in 
> > acpi_parse_table instead of outside track it.
> > 
> > need to revert
> > "
> > commit d8d28f25f33c6a035cdfb1d421c79293d16e5c58
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Thu Jan 17 15:26:42 2008 +0100
> > 
> >     x86: ACPI: fix mapping leaks
> > 
> >     ioremap_early() is stateful, hence we cannot tolerate mapping leaks.
> > "
> > 
> > before appling this patch
> 
> do you mean your patch should be applied first, then the 
> d8d28f25f33c6a03 patch should applied as second?

d8d28f25f33c6a03  is not needed

> 
> Or if d8d28f25f33c6a03 really needs to be reverted to get your system to 
> boot properly, which particular bit of it was causing trouble for you? 
> (or the whole thing?)

we need to call acpi_os_unmap_memory in acpi_table_parse or just after it.

call it in acpi_table_parse is much cleaner

the problem is that acpi_numa_slit_init do bad assumaption that it still can use address after it's callback function.
so we need to copy the slit.

YH
