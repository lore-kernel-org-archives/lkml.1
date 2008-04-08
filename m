Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYDHGyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYDHGyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYDHGx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:53:57 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45509 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYDHGx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:53:56 -0400
Message-ID: <47FB162D.1020506@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2008 12:22:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <47F5F3FA.7060709@linux.vnet.ibm.com> <6599ad830804041211r37848a6coaa900d8bdac40fbe@mail.gmail.com> <47F79102.6090406@linux.vnet.ibm.com> <6599ad830804051023v69caa3d4h6e26ccb420bca899@mail.gmail.com> <47F7BB69.3000502@linux.vnet.ibm.com> <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com> <47F7CC08.4090209@linux.vnet.ibm.com> <6599ad830804051629k3649dbc4na92bb3d0cd7a0492@mail.gmail.com> <47F861C8.7080700@linux.vnet.ibm.com> <6599ad830804072337g2e7b4613hdcc05062dc2ca4e0@mail.gmail.com>
In-Reply-To: <6599ad830804072337g2e7b4613hdcc05062dc2ca4e0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sat, Apr 5, 2008 at 10:38 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  >
>>  > How long does the test run for? How many threads does each client have?
>>
>>  The test on each client side runs for about 10 seconds. I saw the client create
>>  up to 411 threads.
>>
> 
> I'm not convinced that an application that creates 400 threads and
> exits in 10 seconds is particular representative of a high-performance
> application.
> 

I agree, but like I said earlier, this was the easily available ready made
application I found. Do you know of any other highly threaded micro benchmark?

> But I agree that it's an example of something it may be worth trying
> to optimize for.
> 
> You mention that you saw tgid exits - what order did the individual
> threads exit in? If we threw the mm to the last thread in the thread
> group rather than the first, would that help?

The order was different each time. I suspect that when we have too many threads
all exiting at once and they are all running in parallel, I don't know if we can
have ordering or predict the order in which threads exit.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
