Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZFDKw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZFDKw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZFDKwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:52:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:35148 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZFDKwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ZDGWdQvJVa1Y/Ff3HL/ZJFoHfp37pIwqQBT8WFXiuVUp7ifnz4S5WrOMTYvVkdtJp8
         X1pozmIOngApCZeqW4NwGmS1rWQX5ZiLOm2cpLIffWj6jin6fa0IVbEy8LgP7RNReq5o
         agtnAGrqkaz7GlfamNzEEn/6nM4QVcyFDrk4M=
From: Florian Fainelli <florian@openwrt.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] add support for the TI VLYNQ bus
Date: Thu, 4 Jun 2009 12:52:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200906011358.28359.florian@openwrt.org> <20090601220854.a9ddd5ce.akpm@linux-foundation.org>
In-Reply-To: <20090601220854.a9ddd5ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906041252.19613.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 02 June 2009 07:08:54 Andrew Morton, vous avez écrit :
> On Mon, 1 Jun 2009 13:58:27 +0200 Florian Fainelli <florian@openwrt.org> 
wrote:
> > This patch adds support for the TI VLYNQ high-speed,
> > serial and packetized bus. This bus allows external
> > devices to be connected to the System-on-Chip and
> > appear in the main system memory just like any memory
> > mapped peripheral. It is widely used in TI's networking
> > and mutlimedia SoC, including the AR7 SoC.
> >
> >
> > ...
> >
> > +struct vlynq_regs {
> > +	u32 revision;
> > +	u32 control;
> > +	u32 status;
> > +	u32 int_prio;
> > +	u32 int_status;
> > +	u32 int_pending;
> > +	u32 int_ptr;
> > +	u32 tx_offset;
> > +	struct vlynq_mapping rx_mapping[4];
> > +	u32 chip;
> > +	u32 autonego;
> > +	u32 unused[6];
> > +	u32 int_device[8];
> > +};
> > +
> > +#define vlynq_reg_read(reg) readl(&(reg))
> > +#define vlynq_reg_write(reg, val)  writel(val, &(reg))
>
> grumble.  These just make the code harder to follow.  it'd be better to
> open-code readl() and writel() at the callsites.

I do not understand how to fix this. Would an inlined accessors be a better 
solution for you?

Thanks.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
