Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZBSJN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZBSJN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZBSJNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:13:41 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41309 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZBSJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:13:39 -0500
Subject: Re: [patch 1/7] slab: introduce kzfree()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Vrabel <david.vrabel@csr.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20090219101336.9556.A69D9226@jp.fujitsu.com>
References: <499BE7F8.80901@csr.com>
	 <1234954488.24030.46.camel@penberg-laptop>
	 <20090219101336.9556.A69D9226@jp.fujitsu.com>
Date: Thu, 19 Feb 2009 11:13:37 +0200
Message-Id: <1235034817.29813.6.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 10:50 +0000, David Vrabel wrote:
> > > Johannes Weiner wrote:
> > > > +void kzfree(const void *p)
> > > 
> > > Shouldn't this be void * since it writes to the memory?
> > 
> > No. kfree() writes to the memory as well to update freelists, poisoning
> > and such so kzfree() is not at all different from it.

On Thu, 2009-02-19 at 10:22 +0900, KOSAKI Motohiro wrote:
> I don't think so. It's debetable thing.
> 
> poisonig is transparent feature from caller.
> but the caller of kzfree() know to fill memory and it should know.

Debatable, sure, but doesn't seem like a big enough reason to make
kzfree() differ from kfree().

