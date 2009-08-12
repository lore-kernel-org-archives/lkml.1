Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbZHLIqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbZHLIqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbZHLIqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:46:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:44775 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084AbZHLIqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:46:16 -0400
Date: Wed, 12 Aug 2009 10:46:13 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, tytso@mit.edu,
       hch@infradead.org, mfasheh@suse.com, aia21@cantab.net,
       hugh.dickins@tiscali.co.uk, swhiteho@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [16/19] HWPOISON: Enable .remove_error_page for migration aware file systems
Message-ID: <20090812084613.GB32342@wotan.suse.de>
References: <200908051136.682859934@firstfloor.org> <20090805093643.E0C00B15D8@basil.firstfloor.org> <4A7FBFD1.2010208@hitachi.com> <20090810074421.GA6838@basil.fritz.box> <4A80EAA3.7040107@hitachi.com> <20090811071756.GC14368@basil.fritz.box> <20090812080540.GA32342@wotan.suse.de> <20090812082331.GD28848@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812082331.GD28848@basil.fritz.box>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 10:23:31AM +0200, Andi Kleen wrote:
> > page corruption, IMO, because by definition they should be able to
> > tolerate panic. But if they do not know about this change to -EIO
> > semantics, then it is quite possible to cause problems.
> 
> There's no change really. You already have this problem with
> any metadata error, which can cause similar trouble.
> If the application handles those correctly it will also 
> handle hwpoison correctly.

What do you mean metadata error?

To be clear, we're talking about safety given by a panic on any
memory error, versus safety of this hwpoison code (specifically
which removes dirty pagecache pages as -EIO).

