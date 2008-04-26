Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYDZJh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYDZJh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYDZJhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:37:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYDZJhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:37:35 -0400
Date: Sat, 26 Apr 2008 05:37:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Artem.Bityutskiy@nokia.com, Artem Bityutskiy <dedekind@yandex.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Message-ID: <20080426093732.GB17730@infradead.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com> <47F1FF98.9020809@nokia.com> <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com> <47F20DEE.7090105@nokia.com> <84144f020804010433xafc6f28o5a5375ce82903a7a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804010433xafc6f28o5a5375ce82903a7a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 02:33:37PM +0300, Pekka Enberg wrote:
> I don't know how many times I have to say this: you're doing it at the
> wrong level! The reason you want to compile them out is because you've
> added crap like this all over your code paths:
> 
>         ubifs_assert(PageLocked(page));
>         ubifs_assert(!PageChecked(page));
>         ubifs_assert(!PagePrivate(page));
> 
> So instead of arguing about this you really ought to look at what
> SLUB, for example, does. It's perfectly okay to have _debugging
> checks_ compiled out (stuff like verify_inode and such) but at the
> assertion level it makes no sense whatsoever!

Yes, having this in filesystems is not very nice.  If someone feels
very strong about interface assertation we should add them at the
method level boundary so that the interface is verified for all
filesystems.

