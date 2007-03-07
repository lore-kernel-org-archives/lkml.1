Return-Path: <linux-kernel-owner+w=401wt.eu-S2992547AbXCGUWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992547AbXCGUWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992546AbXCGUWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:22:11 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:51259 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965632AbXCGUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Htbuplf73s55pxs0KQJY5DZRZatBa5mMXkXaLMhFpAYyyxfWtprzq9xgeID4IFLcA6/6vm6v15cx3nJi7R08Fr02vHqRSByX95zbkgRm5WjtZlhUaDowQ40T/AGA2NR+5m5seKWbMNFox1kDN2c6AxJxdBAtngZhsW6V+KFzcYE=
Message-ID: <d120d5000703071215w5d08d2b2ve3519f73bdd39b7e@mail.gmail.com>
Date: Wed, 7 Mar 2007 15:15:29 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: PS/2 mouse port missing with kernel >=2.6.19, Sis chipset
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45EF1AAB.40104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45EF1AAB.40104@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> We have multiple reports of PS/2 mouse port not being found
> on Sis 630 and 730 chipsets, starting with Fedora kernel 2.6.19:
>
> 2.6.18:
> Jan 19 08:59:39 mtranch kernel: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M]
> at 0x60,0x64 irq 1,12
> Jan 19 08:59:39 mtranch kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
> Jan 19 08:59:39 mtranch kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
> Jan 19 08:59:39 mtranch kernel: mice: PS/2 mouse device common for all mice
>
> 2.6.19:
> Jan 20 09:22:30 mtranch kernel: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M]
> at 0x60,0x64 irq 1,12
> Jan 20 09:22:30 mtranch kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
> Jan 20 09:22:30 mtranch kernel: mice: PS/2 mouse device common for all mice
>
> I'm pretty sure Fedora doesn't patch any input code, so I wonder
> if some change was made here that could cause this?

There were some issues with AUX IRQ delivery test that is part of AUX
port probe. They should be fixed in the latest mainline. You might be
inetrested in this commit:

1e4865f8d469b1...

-- 
Dmitry
