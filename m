Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0BJVZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:25:01 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:44740 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab0BJVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XRdqmipJeJEnlz09SCBPAN8FT+wlYOlaiwtd2bYCCnLalm46Q1EFeLyVYUptOTggVV
         g3cfFa+K8LxFP7CmSlEuDO9ht3wVW7ksiz7VQaTQUfAuzb9Ip+NK3yVCCLc9d0kPHy96
         IafPjgb0Jk/tCA+6Opx6YzwwQYNwUKkyHCxt4=
Subject: Re: [PATCH 01/17] MTD: create lockless versions of
 {get,put}_mtd_device This will be used to resolve deadlock in block
 translation layer.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1265737574.9195.16.camel@maxim-laptop>
References: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
	 <1265734665-22656-2-git-send-email-maximlevitsky@gmail.com>
	 <1265735693.11509.253.camel@laptop>  <1265736206.9195.4.camel@maxim-laptop>
	 <1265737574.9195.16.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 23:22:33 +0200
Message-ID: <1265836953.8276.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 19:46 +0200, Maxim Levitsky wrote: 
> On Tue, 2010-02-09 at 19:23 +0200, Maxim Levitsky wrote: 
> > On Tue, 2010-02-09 at 18:14 +0100, Peter Zijlstra wrote: 
> > > On Tue, 2010-02-09 at 18:57 +0200, Maxim Levitsky wrote:
> > > > These functions can be used as long as we don't need access to global mtd table, but have
> > > > a pointer to the mtd device.
> > > > 
> > > > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > > > ---

David, I just got a great idea how to resolve the same issue in much
cleaner way.

Why not to drop the mtd table lock before calling the add notifers?
If we assume no add_mtd_device/del_mtd_device running concurrently this
should be ok. After all mtd table lock should protect only the mtd
table.
And the table only purpose it to locate an mtd device by number or name.
This purpose will always be useful, be it a static table or not.

I also remove all that mtd table junk from mtd_blktrans.c

Best regards,
Maxim Levitsky

