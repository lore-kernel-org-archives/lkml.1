Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXDLL25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXDLL25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 07:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXDLL25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 07:28:57 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:35160 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbXDLL24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 07:28:56 -0400
Date: Thu, 12 Apr 2007 13:26:00 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Christoph Hellwig <hch@infradead.org>
cc: Nate Diller <nate.diller@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
Subject: Re: [PATCH 1/17] cramfs: use read_mapping_page
In-Reply-To: <20070412095428.GA22675@infradead.org>
Message-ID: <Pine.LNX.4.64.0704121310090.14457@scrub.home>
References: <20070412024938.27380.54538.patchbomb.py@localhost>
 <20070412024938.27380.87060.patchbomb.py@localhost> <20070412095428.GA22675@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 12 Apr 2007, Christoph Hellwig wrote:

> On Wed, Apr 11, 2007 at 07:49:38PM -0700, Nate Diller wrote:
> > read_mapping_page_async() is going away, so convert its only user to
> > read_mapping_page().  This change has not been benchmarked, however, in
> > order to get real parallelism this wants something completely different,
> > like __do_page_cache_readahead(), which is not currently exported.
> 
> Why is read_mapping_page_async going away?  This probably needs a lot more
> testing, and I'd be much happier if you split it out of the series and
> sent it separately at the end.

That function wasn't fully async anyway, as it would often sleep in 
lock_page(). AFAICT only in the special case of a partial written page 
would this function return a not yet uptodate page.

bye, Roman
