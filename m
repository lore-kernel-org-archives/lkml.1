Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbXLSQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbXLSQ7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXLSQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:59:13 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:4677 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190AbXLSQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:59:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=N7a0849EWM96naCzbN2lAknoqwHyPwwi2Adm3iLkrQ7On2+iJgpRgllWc0EzHbaQb/YORTZFVvuLXIw01QL2YbAwe2FTj7mpGfpSfSBXWCOGbpqfx4R1J7fNj1nJAkSmhUV8+QdIMLTW49P1yHbxECi0rUq8NWA2SjwOU8E4iDo=
Message-ID: <3efb10970712190859j125eb027y89a967280c2c829@mail.gmail.com>
Date: Wed, 19 Dec 2007 17:59:09 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH v2 0/6] atmel_serial: Cleanups, irq handler splitup & DMA
Cc: "Andrew Victor" <linux@maxim.org.za>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King" <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
In-Reply-To: <20071219174742.68e70c6c@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
	 <3efb10970712190757m18f8851cq54061ff109790805@mail.gmail.com>
	 <20071219170935.4df62471@dhcp-252-066.norway.atmel.com>
	 <3efb10970712190840m39876762yb4d31c36723c3b8a@mail.gmail.com>
	 <20071219174742.68e70c6c@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 8c3090b8475e3a3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > but I noticed that I sometimes get an input overrun (ttyS0: 1
> > input overrun(s) ) during stress conditions.
> > This is something I did not notice before, maybe it was already there,
> > or has something changed in this area that it is now more sensitive
> > for this?
> Hmm...is this with or without DMA?

DBGU is without DMA.

> If it's without DMA, something very strange is going on -- the non-DMA
> RX code is almost the only thing left in the hardirq handler, so I
> would really expect overruns to be much less likely to occur now than
> before...

As mentioned, maybe it was already there, but I did not run into it
earlier. I have to figure that out. But, at 115200 and a 1 byte
receive-'fifo' on DBGU, and still interrupt locks somewhere in the
tree up to 300us, it is a simple calculation that we can run into
overrun conditions...
Notice that without these interrupt handler splitup, it was much, much
much worse...

So, for me it is not a big deal, because it is just a terminal, and
with my shaky fingers I usually do not type that fast ;-))

Remy

Kind Regards,

Remy
