Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0BVV2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:28:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50365 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab0BVV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:28:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mXtba9XrBv59yWUe70bu4vbyse09nS0IWumhSJ10XcyDxtd/ANbm6qnmYz6dPTN8GR
         SNzSAp8ywWeeva7aszZQyJkfSr0VZo27Kd9ds/IEPSPqPzjb0ooZ8dOh8PSbDd4KnHib
         hALvsC2NuZ+TQ9RCllCiqp+WkoSQwfDoJwSDY=
Subject: Re: [PATCH 10/15] MTD: nand: make reads using MTD_OOB_RAW affect
 only ECC validation
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       stanley.miao@windriver.com, Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1002222219430.4136@localhost.localdomain>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
	 <1266863982-5258-11-git-send-email-maximlevitsky@gmail.com>
	 <alpine.LFD.2.00.1002222219430.4136@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 23:28:07 +0200
Message-ID: <1266874087.4971.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 22:20 +0100, Thomas Gleixner wrote: 
> On Mon, 22 Feb 2010, Maxim Levitsky wrote:
> 
> > This changes the behavier of MTD_OOB_RAW. It used to read both OOB and data
> > to the data buffer, however you would still need to specify the dummy oob buffer.
> > 
> > This is only used in one place, but makes it hard to read data+oob without ECC
> > test, thus I removed that behavier, and fixed the user.
> > 
> > Now MTD_OOB_RAW behaves just like MTD_OOB_PLACE, but doesn't do ECC validation
> 
> Is this tested against existing user space tools like nanddump ? Can I
> still get the raw data from flash ?

Thats the point.
Userspace doesn't/can't use that mode.
It is not exposed through mtdchar.
Userspace reads the page, and then reads the oob.

It does use MTD_OOB_RAW, but without data buffer, and this path I don't
change.

The only user of this, is the nand itself, when it reads bad block
table.

I confess that I didn't run test that I ported this code correctly.
But I did logically verified many times that the new code works just
like old one.


Best regards,
Maxim Levitsky

