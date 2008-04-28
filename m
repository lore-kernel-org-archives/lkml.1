Return-Path: <linux-kernel-owner+w=401wt.eu-S932636AbYD1HQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbYD1HQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbYD1HPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:15:13 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18262 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765922AbYD1HPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:15:11 -0400
Message-ID: <4815784F.2070601@nokia.com>
Date: Mon, 28 Apr 2008 10:10:07 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: ext Christoph Hellwig <hch@infradead.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Artem.Bityutskiy@nokia.com,
       Artem Bityutskiy <dedekind@yandex.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com> <47F1FF98.9020809@nokia.com> <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com> <47F20DEE.7090105@nokia.com> <84144f020804010433xafc6f28o5a5375ce82903a7a@mail.gmail.com> <20080426093732.GB17730@infradead.org>
In-Reply-To: <20080426093732.GB17730@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 07:15:03.0070 (UTC) FILETIME=[93D9A3E0:01C8A8FF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Christoph Hellwig wrote:
> On Tue, Apr 01, 2008 at 02:33:37PM +0300, Pekka Enberg wrote:
>> I don't know how many times I have to say this: you're doing it at the
>> wrong level! The reason you want to compile them out is because you've
>> added crap like this all over your code paths:
>>
>>         ubifs_assert(PageLocked(page));
>>         ubifs_assert(!PageChecked(page));
>>         ubifs_assert(!PagePrivate(page));
>>
>> So instead of arguing about this you really ought to look at what
>> SLUB, for example, does. It's perfectly okay to have _debugging
>> checks_ compiled out (stuff like verify_inode and such) but at the
>> assertion level it makes no sense whatsoever!
> 
> Yes, having this in filesystems is not very nice.

A technical reason would be more compelling than "not very nice".

> If someone feels
> very strong about interface assertation we should add them at the
> method level boundary so that the interface is verified for all
> filesystems.
> 

The checks are not valid for all file systems.

The point of the checks as preconditions is lost if they moved elsewhere.

VFS code paths are not simple, so the suggestion is impractical anyway.
