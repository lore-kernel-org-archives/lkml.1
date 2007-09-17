Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXIQVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXIQVou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbXIQVol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:44:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:10875 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbXIQVok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aPWakqpganoJV497Z/g5h2gfy5QejRA9RowcJl4jl4qnVaJFf8z/p+VrvK3er584dHSCGn9IvSQcmpM8jyu2gjR+PfZN00lM5zbeB0espUGD4nEmJiHKBQkm4/bqLEabhSclWp/6cVbgIS/7jVCRTAeAqZsd16WNgQ2cSb8daYU=
Message-ID: <46EEF543.7060901@gmail.com>
Date: Mon, 17 Sep 2007 23:44:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] revert ath5k ioread32()/iowrite32() usage - use readl()/writel(),
 we're MMIO-only
References: <43e72e890709171334y321dc2c8ke255a126a733dad6@mail.gmail.com> <46EEE735.5050306@gmail.com> <46EEEA9B.70407@garzik.org>
In-Reply-To: <46EEEA9B.70407@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2007 10:59 PM, Jeff Garzik wrote:
> Jiri Slaby wrote:
>> NACK, this is wrong. iomap returns platform dependant return value,
>> which may or
> 
> Incorrect.  readl() and writel() work just fine on all existing
> platforms where Atheros may be used.

Ok, this is what Alan Cox wrote about that and you didn't reply to it, so I
thought he's right. Anyway I wouldn't rely on iomap that it will never be
changed even on x86 -- what's the (performance) impact of having ioread instead
of readl? How much data are transferred this way?

<cite from="http://lkml.org/lkml/2007/8/25/50">
On Sat, 25 Aug 2007 04:56:19 -0400
Jeff Garzik <jgarzik@pobox.com> wrote:

> If the driver knows its MMIO, using readX/writeX after pci_iomap() is
> just fine, for all current implementations, and it makes sense that way.

There is nothing that guarantees this is permitted, any more than there
is anything saying not to use outb/outl. Some of the implementations do
quite strange things. It may happen to work but its not in the
documentation or the comments.

If you want to change this then you need to check the existing usages and
update all the docs if its safe, oh and tell the sparc64 pcmcia people to
take a hike, which is probably not a big problem.
</cite>

Please, can anybody clarify it?

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
