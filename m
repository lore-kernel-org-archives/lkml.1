Return-Path: <linux-kernel-owner+w=401wt.eu-S1763188AbYEFScl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763188AbYEFScl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763296AbYEFSc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:32:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43614 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYEFScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:32:25 -0400
Message-ID: <4820A431.3000600@firstfloor.org>
Date: Tue, 06 May 2008 20:32:17 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] mm/cgroup.c add error check
References: <20080506195216.4A6D.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <87wsm7bo1n.fsf@basil.nowhere.org> <2f11576a0805060602gf4cf0f9t85391939146efccf@mail.gmail.com>
In-Reply-To: <2f11576a0805060602gf4cf0f9t85391939146efccf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>  > on heavy workload, call_usermodehelper() may failure
>>  > because it use kzmalloc(GFP_ATOMIC).
>>
>>  Better just fix it to not use GFP_ATOMIC in the first place.
> 
> Ah, makes sense.
> I'll try toi create that patch.

Thanks.

> 
> but if GFP_KERNEL is used, We still need error check, IMHO.

Yes, but no retry (or if you're sure you cannot fail use __GFP_NOFAIL
too, but that is nasty because it has some risk of deadlock under severe
oom conditions)

-Andi


