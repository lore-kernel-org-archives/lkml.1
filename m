Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYBXQjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYBXQjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYBXQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:39:22 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:6991 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYBXQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:39:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DfuWjlBT/+440M+1MESi+z5ryGWvfbR7ZNOlgOmJgvh/+VCgNEdGI0CLeUT1ePE1AtY/NsRKQngiq3eTvvOxbeluYZOOmRoKtFEgTkXiF/7Klva+qS59IIIsHFqb1M6MV4WiIsIniX1K/G16+D5QF7uA9rWnczIcrmbNHvALNHY=
Message-ID: <f19298770802240839w2c19fd52vb0d170359ba56fc5@mail.gmail.com>
Date: Sun, 24 Feb 2008 19:39:19 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200802241529.50967.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <20080223112436.GA31304@elte.hu>
	 <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
	 <200802241529.50967.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 5:29 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Saturday 23 February 2008 12:32:50 Alexey Zaytsev wrote:
>  > The problem is not with enabling both b43 and bcm43xx (will, whis won't work
>  > anyway, and there is no chance fixing it). The problem is with enabling the
>  > bcm43xx wifi driver and the b44 Ethernet driver. The ethernet driver then
>  > wrongly autosolects some config options that prevent the bcm43xx
>  > driver from loading, so I'm left with either no wifi or no ethenet.
>
>  Ok, so I just tested this on a machine and it is _not_ true.
>  It works just fine to run b44/ssb with bcm43xx in parallel.
>
>  Can you please stop fooling me and spreading this FUD?
>

The ony way I see this was possible, you manually changed the
module loading order, so that the b43xx module was loaded prior
to the ssb and b44 modules. Right? Or the b43xx driver was built
statically and the b44 and the ssb as modules.

Looks like this, kind of, ruins my statement that is is impossible to get
working wifi in 2.6.24. Sorry, it was not intensinal. ;)

But there still are lots of valid combinations where the b43xx driver
silently won't work. E.g. when either the ssb or the b44 modules are
loaded prior to it, or when either of them are built statically (building
the b43xx driver staticaly won't help here). And my patch fixes them.

So, my statement goes, the bug stays. Agreed?
