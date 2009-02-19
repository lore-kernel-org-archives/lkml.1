Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZBSSOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZBSSOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZBSSO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:14:28 -0500
Received: from waste.org ([66.93.16.53]:50426 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZBSSO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:14:27 -0500
Subject: Re: [patch 1/7] slab: introduce kzfree()
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Vrabel <david.vrabel@csr.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <Pine.LNX.4.64.0902191616250.8594@blonde.anvils>
References: <499BE7F8.80901@csr.com>
	 <1234954488.24030.46.camel@penberg-laptop>
	 <20090219101336.9556.A69D9226@jp.fujitsu.com>
	 <1235034817.29813.6.camel@penberg-laptop>
	 <Pine.LNX.4.64.0902191616250.8594@blonde.anvils>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 12:02:36 -0600
Message-Id: <1235066556.3166.26.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 16:34 +0000, Hugh Dickins wrote:
> On Thu, 19 Feb 2009, Pekka Enberg wrote:
> > On Wed, 2009-02-18 at 10:50 +0000, David Vrabel wrote:
> > > > > Johannes Weiner wrote:
> > > > > > +void kzfree(const void *p)
> > > > > 
> > > > > Shouldn't this be void * since it writes to the memory?
> > > > 
> > > > No. kfree() writes to the memory as well to update freelists, poisoning
> > > > and such so kzfree() is not at all different from it.
> > 
> > On Thu, 2009-02-19 at 10:22 +0900, KOSAKI Motohiro wrote:
> > > I don't think so. It's debetable thing.
> > > 
> > > poisonig is transparent feature from caller.
> > > but the caller of kzfree() know to fill memory and it should know.
> > 
> > Debatable, sure, but doesn't seem like a big enough reason to make
> > kzfree() differ from kfree().
> 
> There may be more important things for us to worry about,
> but I do strongly agree with KOSAKI-san on this.
> 
> kzfree() already differs from kfree() by a "z": that "z" says please
> zero the buffer pointed to; "const" says it won't modify the buffer
> pointed to.  What sense does kzfree(const void *) make?  Why is
> keeping the declarations the same apart from the "z" desirable?
> 
> By all means refuse to add kzfree(), but please don't add it with const.
> 
> I can see that the "const" in kfree(const void *) is debatable
> [looks to see how userspace free() is defined: without a const],
> I can see that it might be nice to have some "goesaway" attribute
> for such pointers instead; but I don't see how you can argue for
> kzalloc(const void *).

This is what Linus said last time this came up:

http://lkml.org/lkml/2008/1/16/227

-- 
http://selenic.com : development and support for Mercurial and Linux


