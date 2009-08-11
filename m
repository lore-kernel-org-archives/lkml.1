Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZHKVyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZHKVyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZHKVyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:54:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491AbZHKVyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:54:10 -0400
Date: Tue, 11 Aug 2009 14:52:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "NeilBrown" <neilb@suse.de>
Cc: sage@newdream.net, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
Message-Id: <20090811145258.6cd823d6.akpm@linux-foundation.org>
In-Reply-To: <8604b01355a1ff1ec6397d223c28b1d5.squirrel@neil.brown.name>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
	<8604b01355a1ff1ec6397d223c28b1d5.squirrel@neil.brown.name>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 08:03:52 +1000 (EST)
"NeilBrown" <neilb@suse.de> wrote:

> On Tue, August 4, 2009 6:54 am, Sage Weil wrote:
> > The kzalloc mempool does not re-zero items that have been used and then
> > returned to the pool.  Manually zero the allocated multipath_bh instead.
> >
> > CC: linux-raid@vger.kernel.org
> > CC: Neil Brown <neilb@suse.de>
> > CC: <stable@kernel.org>

Sage, why did you cc stable@kernel.org?  The patch fixes some bug? 
What is it?  Why is the fix sufficiently important to warrant
backporting?

> Acked-by: NeilBrown <neilb@suse.de>
> 

Thanks, I'll merge it once the above is understood.

> 
> In fact, you don't even need the memset.  After allocation
> no assumptions are made about the content of the structure.
> Every field is immediately initialised except retry_list, which
> is never accessed until after the object is placed on a list.h list.
> 
> So this code never needed kzalloc_pool.

Well, that's a bit of a functional change so let us (ie: you ;)) do
that separately?

