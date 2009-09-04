Return-Path: <linux-kernel-owner+w=401wt.eu-S934401AbZIDW3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbZIDW3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934350AbZIDW3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:29:08 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33585 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934024AbZIDW3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:29:08 -0400
Subject: Re: [PATCH v2 2/5] kmemleak: add clear command support
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
In-Reply-To: <20090904202653.GE4949@mosca>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
	 <1251956140-5499-3-git-send-email-lrodriguez@atheros.com>
	 <1251996731.22485.25.camel@pc1117.cambridge.arm.com>
	 <20090904202653.GE4949@mosca>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 04 Sep 2009 23:28:47 +0100
Message-Id: <1252103327.21380.6.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2009 22:28:48.0219 (UTC) FILETIME=[123FFAB0:01CA2DAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 13:26 -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 03, 2009 at 09:52:11AM -0700, Catalin Marinas wrote:
> > On Thu, 2009-09-03 at 01:35 -0400, Luis R. Rodriguez wrote:
> > > In an ideal world your kmemleak output will be small,
> > > when its not you can use the clear command to ingore previously
> > > annotated kmemleak objects. We do this by painting them black.
> > 
> > Making the objects "black" means that they are completely ignored by
> > kmemleak and they are assumed not to contain any valid references.
> > Therefore they won't be scanned and many of the newly allocated objects
> > would be false positives.
> 
> Got it, BTW can you elaborate as to why painting objects black would
> create false positives for newly allocated objects? I fail to understand
> why.

Black objects are not scanned by kmemleak. Making valid objects black as
per your patch, they may (actually quite likely) contain pointers to
newly allocated objects. Since they won't be scanned, the newly
allocated objects are reported as unreferenced as no pointers to them
were found during scanning.

-- 
Catalin

