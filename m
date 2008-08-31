Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbYHaN6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbYHaN6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbYHaN6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:58:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:50704 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbYHaN6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=ear7TK3JiGhgVvXKfX13zG9JraCqN8YsTxOsDAhhZ9D9d0hxHenmFT0L/mjJR3DFff
         8cn/7IVn539dPwXC4RP0vm9dsz1F1Sx3HcjXGoX7BqNT1CjeS6kYT4T4jQyoBKMe3cF0
         x3mLpzrwoxYMPSuY4o1l35Zhc4Xb2E8ShqE6U=
Message-ID: <48BAA364.7080503@panasas.com>
Date: Sun, 31 Aug 2008 16:57:56 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc5 1/29] mdb: export ioapic read routines and
 detected ioapic count
References: <200808290547.m7T5leOa016106@wolfmountaingroup.com>
In-Reply-To: <200808290547.m7T5leOa016106@wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff, general comment: can you please send your patches as replies
to a leading message so they all be linked as a single thread?
Threading them together is helpful for maintaining several
versions of your patchset and it's simpler to ignore if one's
not really interested in this topic at all.

Benny

On Aug. 29, 2008, 8:47 +0300, jmerkey@wolfmountaingroup.com wrote:
> export ioapic read routines and detected ioapic count.
> 
> 
> Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)
> 
> --- a/arch/x86/kernel/io_apic_32.c	2008-08-28 14:19:19.000000000 -0600
> +++ b/arch/x86/kernel/io_apic_32.c	2008-08-28 16:07:46.000000000 -0600
> @@ -75,6 +75,7 @@
>  /* I/O APIC entries */
>  struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
>  int nr_ioapics;
> +EXPORT_SYMBOL(nr_ioapics);
>  
>  /* MP IRQ source entries */
>  struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
> @@ -120,12 +121,13 @@
>  		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
>  }
>  
> -static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
> +unsigned int io_apic_read(unsigned int apic, unsigned int reg)
>  {
>  	struct io_apic __iomem *io_apic = io_apic_base(apic);
>  	writel(reg, &io_apic->index);
>  	return readl(&io_apic->data);
>  }
> +EXPORT_SYMBOL(io_apic_read);
>  
>  static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

