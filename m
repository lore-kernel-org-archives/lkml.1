Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZKEOoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZKEOoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbZKEOoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:44:21 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:56138 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699AbZKEOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=wIyyuPKcagzj5XNLCeoMXXDOL7XqR0lDr7tXy4H3hTcH4QGjbUmH2JHN0lGwnP/Lee
         ZG24x28D1+ny/t4FjX2fjInPucgZagNqkGek9MdyIFPW0LHOQQ1UzWxkx2xJICeRPqE+
         lkaM2IbrbEzZw+gadHXCZDUUGuceR2QlQODDw=
Subject: Re: [PATCH -queue v0 4/6] [loongson] add basic fuloong2f support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       huhb@lemote.com, yanh@lemote.com, Zhang Le <r0bertz@gentoo.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
In-Reply-To: <20091105131603.GA18232@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	 <0f805f7d12c5a7cbcc125ba4a1b70113ec2047a6.1257325319.git.wuzhangjin@gmail.com>
	 <20091105131603.GA18232@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 05 Nov 2009 22:44:22 +0800
Message-ID: <1257432262.3067.42.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-11-05 at 14:16 +0100, Ralf Baechle wrote:
> > +
> > +	if ((LOONGSON_INTISR & LOONGSON_INTEN) & LOONGSON_INT_BIT_INT0) {
> > +		imr = inb(0x21) | (inb(0xa1) << 8);
> > +		isr = inb(0x20) | (inb(0xa0) << 8);
> > +		isr &= ~0x4;	/* irq2 for cascade */
> > +		isr &= ~imr;
> > +		irq = ffs(isr) - 1;
> > +	}
> 
> Any reason why you're not using i8259_irq() from <asm/i8259.h> here?
> That function not only gets the locking right, it also minimizes the number
> of accesses to the i8259 - which even on modern silicon can be stuningly
> slow.
> 

Seems there are some differences between here and the i8259_irq(), I
forget the details, perhaps "Yan Hua" can give a detail explaination.

> > +#if 1
> > +	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &val);
> > +	printk(KERN_INFO "cs5536 acc latency 0x%x\n", val);
> > +	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xc0);
> > +#endif
> 
> Seems like left over debug code?
> 
> > +	return;
> > +}
> 
> And a useless return statement at the end of a void function.
> 

Okay, will remove them later.

Regards,
	Wu Zhangjin

