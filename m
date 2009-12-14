Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZLNEaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZLNEaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbZLNEa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 23:30:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZLNEa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 23:30:28 -0500
Message-ID: <4B25BF39.5020401@redhat.com>
Date: Sun, 13 Dec 2009 23:29:45 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: lwoodman@redhat.com, akpm@linux-foundation.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091211164651.036f5340@annuminas.surriel.com>	 <28c262360912131614h62d8e0f7qf6ea9ab882f446d4@mail.gmail.com>	 <4B25BA6E.5010002@redhat.com> <28c262360912132019u7c0b8efpf89b11a6cbe512b3@mail.gmail.com>
In-Reply-To: <28c262360912132019u7c0b8efpf89b11a6cbe512b3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2009 11:19 PM, Minchan Kim wrote:
> On Mon, Dec 14, 2009 at 1:09 PM, Rik van Riel<riel@redhat.com>  wrote:

>> A simpler solution may be to use sleep_on_interruptible, and
>> simply have the process continue into shrink_zone() if it
>> gets a signal.
>
> I thought it but I was not sure.
> Okay. If it is possible, It' more simple.
> Could you repost patch with that?

Sure, not a problem.

>          +The default value is 8.
>          +
>          +=============================================================
>
>
>      I like this. but why do you select default value as constant 8?
>      Do you have any reason?
>
>      I think it would be better to select the number proportional to NR_CPU.
>      ex) NR_CPU * 2 or something.
>
>      Otherwise looks good to me.
>
>
> Pessimistically, I assume that the pageout code spends maybe
> 10% of its time on locking (we have seen far, far worse than
> this with thousands of processes in the pageout code).  That
> means if we have more than 10 threads in the pageout code,
> we could end up spending more time on locking and less doing
> real work - slowing everybody down.
>
> I rounded it down to the closest power of 2 to come up with
> an arbitrary number that looked safe :)
> ===
>
> We discussed above.
> I want to add your desciption into changelog.

The thing is, I don't know if 8 is the best value for
the default, which is a reason I made it tunable in
the first place.

There are a lot of assumptions in my reasoning, and
they may be wrong.  I suspect that documenting something
wrong is probably worse than letting people wonder out
the default (and maybe finding a better one).

-- 
All rights reversed.
