Return-Path: <linux-kernel-owner+w=401wt.eu-S1030496AbXCLQJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030496AbXCLQJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXCLQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:09:41 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:45491 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030496AbXCLQJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:09:40 -0400
Message-ID: <45F57E7D.6080604@sw.ru>
Date: Mon, 12 Mar 2007 19:23:25 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Emelianov <xemul@sw.ru>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru> <m14porwq1c.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14porwq1c.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Pavel Emelianov <xemul@sw.ru> writes:
> 
> 
>>Pages are charged to their first touchers which are
>>determined using pages' mapcount manipulations in
>>rmap calls.
> 
> 
> NAK pages should be charged to every rss group whose mm_struct they
> are mapped into.
For these you essentially need per-container page->_mapcount counter,
otherwise you can't detect whether rss group still has the page in question being mapped
in its processes' address spaces or not.

1. This was discussed before and considered to be ok by all the resource management
   involved people.
2. this can be done with a-la page beancounters which are used in OVZ for shared
   fractions accounting. It's a next step forward.

If you know how to get "pages should be charged to every rss group whose mm_struct they
are mapped into" w/o additional pointer in struct page, please throw me an idea.

Thanks,
Kirill
