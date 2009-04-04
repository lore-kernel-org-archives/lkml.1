Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZDDQR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZDDQR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZDDQRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:17:50 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:54983 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZDDQRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v4ntMoI89LOc5Lq+Dk5mpFfZU4wvKAZui/f5KMKqzeRaNnYZDnEJTiZsp6b9LQk+FM
         ulqKdTOwm5B1FLFFH7WJrIQ0rJ9icBBvuXwTjDBr3YMfJvLsBPJRuKJzcNkZiAGmt3AX
         o1o7jHtbXgUZm5j5Fy95n9MJRN5J1ewG6Jemk=
MIME-Version: 1.0
In-Reply-To: <1238855797.4068.6.camel@macbook.infradead.org>
References: <200903260042.42091.david-b@pacbell.net>
	 <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
	 <1238742215.20906.99.camel@localhost.localdomain>
	 <a95a62fe0904031300i82bdf42h5bc854a002e0091e@mail.gmail.com>
	 <1238855797.4068.6.camel@macbook.infradead.org>
Date: Sat, 4 Apr 2009 09:17:46 -0700
Message-ID: <a95a62fe0904040917w6396443bj3278abbae83df46@mail.gmail.com>
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dedekind@infradead.org, David Brownell <david-b@pacbell.net>,
       Linux MTD <linux-mtd@lists.infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/09, David Woodhouse <dwmw2@infradead.org> wrote:
> I really do think I want this to avoid the need for 64-bit ioctls
> (except maybe MEMERASE64).

So, after adding the sysfs patches, we have two remaining sets of MTD
operations that are limited to 32-bit offsets:

The first set is required to support >4GiB NAND devices: MEMERASE,
MEMREADOOB, and MEMWRITEOOB.

The second set might not make sense at all for most NAND devices:
MEMLOCK, MEMUNLOCK, and MEMGETREGIONINFO.  Maybe it would be nice to
extend them for consistency's sake, but it is possible that they will
never be needed on any >4GiB flash chip.

How would you like to handle these?  Any thoughts on what the
interfaces (sysfs or otherwise) might look like?

Thanks.
