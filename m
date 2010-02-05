Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab0BERFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:05:13 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:46742 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab0BERFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:05:09 -0500
X-Greylist: delayed 1941 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2010 12:05:09 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kjsdmlmM3kBQo2oThPRwX4kDz5ZtCFVFH3FeU/esW5DiltUarGFRxwz9gOvXwN4663
         sYFhIhZgSdpLoinYXZUzn2+pQIb/+wGSUVtOjgMEuPE2XKkZ8EAe/TEVf/AcO2U6YvDP
         /f4fm9Iz3p4zv9lEVDmz2sQ7HH9/uy79xPdNo=
Subject: Re: [PATCH 13/17] MTD: export few functions from nand_base.c
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "stanley.miao" <stanley.miao@windriver.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
       Artem Bityutskiy <dedekind1@gmail.com>, joern <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4B6B8338.5060608@windriver.com>
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
	 <1265326257-4446-14-git-send-email-maximlevitsky@gmail.com>
	 <4B6B8338.5060608@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 19:05:04 +0200
Message-ID: <1265389504.18186.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 10:32 +0800, stanley.miao wrote: 
> Maxim Levitsky wrote:
> > This exports:
> >
> > nand_do_read_oob
> > nand_do_write_oob
> >   
> 
> nand_do_read_oob and nand_do_write_oob can't be exported. They are internal
> functions in NAND subsystem. If you want use them, please use mtd->read_oob
> and mtd->write_oob.
> 
> Stanley.
> 
> > nand_get_device
> > nand_put_device
> >
> > This functions will be used to implement custom oob based
> > bad block handling in upcoming smartmedia common module
> >

Actually I don't like this patch ether.

The problem is that nand_erase_nand first takes the lock, and then calls
the ->block_bad.

I could make the ->block_bad always take the lock (and this will allow
using ->read_oob) by first checking that all erase blocks are good, and
then doing the erase.
This would change the behavior slightly (Now if you attempt to erase
several erase blocks and one of them is marked as bad, erase stops at
first bad block. With the change, erase will fail completely.
Is this ok?

Best regards,
Maxim Levitsky



