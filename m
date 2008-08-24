Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYHXP3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYHXP3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHXP3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:29:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37769 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYHXP3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=WOfaR3BkvDiPA8fMMljNMQ3GEK4eQ7ZCuIbjdtpBv5DBYZxodiY1fPd+qeDkDC3XLc
         RaVn65c5s7G4q4owusutFk2E2fkpNEjFwSutkGBLUBk3e8uoqyABZ71z9TN5+qTfs8Bv
         9OvZ4jdU9AAI4B7WM7Ei9RBaIuh1Yoz5PCP54=
Message-ID: <48B17E56.3060106@panasas.com>
Date: Sun, 24 Aug 2008 18:29:26 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help with compiler warning
References: <48AE1802.5090301@lwfinger.net>
In-Reply-To: <48AE1802.5090301@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug. 22, 2008, 4:36 +0300, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In drivers/pcmcia/cardbus.c, the following statement
> 
>          memcpy_fromio(ptr, s->cb_cis_virt + addr, len);
> 
> generates the warning
> 
>    CC [M]  drivers/pcmcia/cardbus.o
> include/asm/io_32.h: In function ‘memcpy_fromio’:
> include/asm/io_32.h:151: warning: passing argument 2 of ‘__memcpy’ 
> discards qualifiers from pointer target type
> 
> s->cb_cis_virt is "void __iomem" and addr is uint.
> 
> What cast does argument 2 need to silence the warning?

memcpy_fromio takes a (const volatile void __iomem *) for the 
src address.

Benny

> 
> Thanks,
> 
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

