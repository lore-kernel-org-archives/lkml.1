Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbZIDU0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbZIDU0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933960AbZIDU0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:26:52 -0400
Received: from mail.atheros.com ([12.36.123.2]:15710 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933959AbZIDU0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:26:51 -0400
Date: Fri, 4 Sep 2009 13:26:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [PATCH v2 2/5] kmemleak: add clear command support
Message-ID: <20090904202653.GE4949@mosca>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
 <1251956140-5499-3-git-send-email-lrodriguez@atheros.com>
 <1251996731.22485.25.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1251996731.22485.25.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 09:52:11AM -0700, Catalin Marinas wrote:
> On Thu, 2009-09-03 at 01:35 -0400, Luis R. Rodriguez wrote:
> > In an ideal world your kmemleak output will be small,
> > when its not you can use the clear command to ingore previously
> > annotated kmemleak objects. We do this by painting them black.
> 
> Making the objects "black" means that they are completely ignored by
> kmemleak and they are assumed not to contain any valid references.
> Therefore they won't be scanned and many of the newly allocated objects
> would be false positives.

Got it, BTW can you elaborate as to why painting objects black would
create false positives for newly allocated objects? I fail to understand
why.

> You may want to make them "gray" and only those which were reported as
> unreferenced, something like below:
> 
>         if ((object->flags & OBJECT_REPORTED) && unreferenced_object(object))
>                 make_gray_object(object->pointer)

Thanks, will use this.

  Luis
