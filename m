Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0BEJak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:30:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:55542 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab0BEJaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:30:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cSeKPtIZuWxRIGx2vrzLvW+1ff+hpnYzxrN1wJKv+WUeyHthtKeqYhZRV1dYRNgFC2
         om6Ib5ZhLQMroZPgcBhoE5uX6KQvORv/5UooksLgukr7J1+8SZYgDFQQwujYZZrotqrB
         n/U4NyYYLZX/ChEeWPwJF9dL9e0FBlhTOdIXc=
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
Date: Fri, 05 Feb 2010 11:30:34 +0200
Message-ID: <1265362234.15383.14.camel@maxim-laptop>
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

I would be happy to use these, and I tried to do so.
However this leads to deadlock, because ->block_bad can (and is) called
with controller lock (nand_get_device), thus if I call ->read_oob I will
get deadlock.

Best regards,
Maxim Levitsky

