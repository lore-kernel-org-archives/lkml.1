Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbXGDDtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbXGDDtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXGDDtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:49:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:44907 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbXGDDtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Ct5WtR9ZkQrSxCWvraEJuczXIw7qjakxhJhrqi/AkXbCNAVk4BgjEHSq2YaXYEF8ovrXXEhd52c983eoBOHpImt/3xzGQSYEv+IDX8un1JefF8LuABUEFseqrzFWZFuvjuHnL+rSrya+FAlS4yixpv7n+mCcwHGXyTZaYImwwN0=
Message-ID: <468B18BF.6040207@gmail.com>
Date: Wed, 04 Jul 2007 12:49:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] libata_acpi: A different strategy for using ACPI information
References: <20070703155417.11d81c75@the-village.bc.nu>
In-Reply-To: <20070703155417.11d81c75@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Lots of BIOSen simply return the BIOS set modes via the ACPI methods and
> pass back the values you give it across suspend/resume. Thus instead of
> trying to do clever stuff with this data we instead use it as a way to
> take a sneak peak at cable type information when viable. This should help
> us catch more of the laptops that do weird stuff, the VIA SATA bridges
> and the totally horked Nvidia cable handling.
> 
> For now its only used by the VIA and AMD/NV driver until we get a better
> idea of whether this is a sensible idea or not.
> 
> Opinions ?

If you don't do _STM first, it basically boils down to reading BIOS
setting during boot.  Over suspend/resume cycle, the values are
preserved by libata-acpi.  At this point, I think honoring the BIOS
setting is the right thing to do.  It just took us too long and I'm not
too sure about using ACPI for this.  It's generic so it's certainly
better in some aspect.  It's just a bit obfuscating, IMHO.

-- 
tejun
