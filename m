Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbZHLI52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbZHLI52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932202AbZHLI51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:57:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52054 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbZHLI51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:57:27 -0400
Date: Wed, 12 Aug 2009 10:57:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, tytso@mit.edu,
       hch@infradead.org, mfasheh@suse.com, aia21@cantab.net,
       hugh.dickins@tiscali.co.uk, swhiteho@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [16/19] HWPOISON: Enable .remove_error_page for
	migration aware file systems
Message-ID: <20090812085727.GE28848@basil.fritz.box>
References: <200908051136.682859934@firstfloor.org> <20090805093643.E0C00B15D8@basil.firstfloor.org> <4A7FBFD1.2010208@hitachi.com> <20090810074421.GA6838@basil.fritz.box> <4A80EAA3.7040107@hitachi.com> <20090811071756.GC14368@basil.fritz.box> <20090812080540.GA32342@wotan.suse.de> <20090812082331.GD28848@basil.fritz.box> <20090812084613.GB32342@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812084613.GB32342@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 10:46:13AM +0200, Nick Piggin wrote:
> On Wed, Aug 12, 2009 at 10:23:31AM +0200, Andi Kleen wrote:
> > > page corruption, IMO, because by definition they should be able to
> > > tolerate panic. But if they do not know about this change to -EIO
> > > semantics, then it is quite possible to cause problems.
> > 
> > There's no change really. You already have this problem with
> > any metadata error, which can cause similar trouble.
> > If the application handles those correctly it will also 
> > handle hwpoison correctly.
> 
> What do you mean metadata error?

e.g. when there's an write error on the indirect block or any
other fs metadata. This can also cause you to lose data. The error 
reporting also works through the address space like with hwpoison,
so it only gets reported once.

I'm not really against fixing that (make the error more sticky
as Fengguang puts it), but I don't think it needs to be mixed
with hwpoison.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
