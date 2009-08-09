Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbZHIFhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbZHIFhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 01:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZHIFhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 01:37:23 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47544 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZHIFhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 01:37:22 -0400
Subject: Re: [UBI UBIFS] replace vmalloc with kmalloc
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: JiSheng Zhang <jszhang3@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
In-Reply-To: <20090807232846.34bffdeb@ustc>
References: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com>
	 <4A7BF1C3.4050602@nokia.com>  <20090807232846.34bffdeb@ustc>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Aug 2009 08:35:32 +0300
Message-Id: <1249796132.9157.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Aug 2009 05:37:04.0864 (UTC) FILETIME=[6D7D9600:01CA18B3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 23:28 +0800, JiSheng Zhang wrote:
> Adrian Hunter <adrian.hunter@nokia.com> wrote:
> > 
> > vmalloc allows large (> 128KiB) buffers, but kmalloc doesn't.
> > So we presently have no choice but to use vmalloc.
> 
> But vmalloced buffer can't be easily passed to DMA, is there better choice?

We use vmalloc-ed buffers is when we need to do something with whole
eraseblocks, which may be 128KiB, or even 256KiB. So in general, we
cannot just s/kmalloc/vmalloc/. We should invent something trickier.

You should probably think about some generic way to solve problems like
this. May be some MTD-specific library could be created. You could
implement something like the flexible arrays, but with DMA stuff in mind
(e.g., adding a parameter which specifies allocation order, because for
DMA you may want to allocate more than one physically contiguous page).
Or you may even improve the existing flexible arrays to suit your needs.
Take a look here:
http://lwn.net/Articles/345273/

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

