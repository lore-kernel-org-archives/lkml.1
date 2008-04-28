Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbYD1JEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbYD1JEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYD1JDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:03:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYD1JDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:03:50 -0400
Date: Mon, 28 Apr 2008 05:03:46 -0400
From: ext Christoph Hellwig <hch@infradead.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: ext Christoph Hellwig <hch@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Artem.Bityutskiy@nokia.com,
       Artem Bityutskiy <dedekind@yandex.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Message-ID: <20080428090346.GB14100@infradead.org>
References: <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com> <47F1FF98.9020809@nokia.com> <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com> <47F20DEE.7090105@nokia.com> <84144f020804010433xafc6f28o5a5375ce82903a7a@mail.gmail.com> <20080426093732.GB17730@infradead.org> <4815784F.2070601@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4815784F.2070601@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:10:07AM +0300, Adrian Hunter wrote:
>>> So instead of arguing about this you really ought to look at what
>>> SLUB, for example, does. It's perfectly okay to have _debugging
>>> checks_ compiled out (stuff like verify_inode and such) but at the
>>> assertion level it makes no sense whatsoever!
>>
>> Yes, having this in filesystems is not very nice.
>
> A technical reason would be more compelling than "not very nice".

These checks are if properly maintained not harmful for the code,
but they make the code less readable and there's of course the chance
that they get out of sync.  That's why the term "not very nice" is
entirely apropinquate here.

>> If someone feels
>> very strong about interface assertation we should add them at the
>> method level boundary so that the interface is verified for all
>> filesystems.
>>
>
> The checks are not valid for all file systems.
>
> The point of the checks as preconditions is lost if they moved elsewhere.
>
> VFS code paths are not simple, so the suggestion is impractical anyway.

Most of these checks are indeed generic.  Those that arise from special
filesystem invariants like not having unmapped buffers due to
implementing ->page_mkwrite should for now be checked in the filesystem,
although I'd like to make sure this is true for all filesystems
long-term.
