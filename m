Return-Path: <linux-kernel-owner+w=401wt.eu-S1762566AbYDAPb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566AbYDAPb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759972AbYDAPU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:20:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:22386 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759404AbYDAPU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:20:27 -0400
Message-ID: <47F2516A.3000302@nokia.com>
Date: Tue, 01 Apr 2008 18:14:50 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <dedekind@yandex.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 20/26] UBIFS: add VFS operations
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>	 <1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com>	 <84144f020804010508k3099b2bagf2f1c0d2747a983@mail.gmail.com>	 <47F22DD3.4060003@yandex.ru> <84144f020804010612iec1c2d9xc9096f8cc3cd9d4d@mail.gmail.com> <47F240F6.3080108@nokia.com>
In-Reply-To: <47F240F6.3080108@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2008 15:20:03.0926 (UTC) FILETIME=[DC289F60:01C8940B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> Pekka Enberg wrote:
>>>  Yeah, this is also a guarding thing. When a dirty page is released
>>>  the budget which was allocated for it has to be freed. If this function
>>>  is called, then the budget was not freed, which must never happen.
>>
>> So what guarantees that no one calls invalidate_complete_page() or
>> fallback_migrate_page(), for example?
> 
> At the first glance it looks like it might be called, but for clean pages,
> which is not the problem, but there is this assert which may give fake
> alarm. Need to look closer at this. Thanks for the note.

Dirty pages are not released.

In UBIFS, clean pages do not have PagePrivate(page) set and so releasepage() is not called.
