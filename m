Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbZLNEKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbZLNEKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZLNEKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 23:10:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbZLNEKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 23:10:03 -0500
Message-ID: <4B25BA6E.5010002@redhat.com>
Date: Sun, 13 Dec 2009 23:09:18 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: lwoodman@redhat.com, akpm@linux-foundation.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091211164651.036f5340@annuminas.surriel.com> <28c262360912131614h62d8e0f7qf6ea9ab882f446d4@mail.gmail.com>
In-Reply-To: <28c262360912131614h62d8e0f7qf6ea9ab882f446d4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2009 07:14 PM, Minchan Kim wrote:

> On Sat, Dec 12, 2009 at 6:46 AM, Rik van Riel<riel@redhat.com>  wrote:

>> If too many processes are active doing page reclaim in one zone,
>> simply go to sleep in shrink_zone().

> I am worried about one.
>
> Now, we can put too many processes reclaim_wait with NR_UNINTERRUBTIBLE state.
> If OOM happens, OOM will kill many innocent processes since
> uninterruptible task
> can't handle kill signal until the processes free from reclaim_wait list.
>
> I think reclaim_wait list staying time might be long if VM pressure is heavy.
> Is this a exaggeration?
>
> If it is serious problem, how about this?
>
> We add new PF_RECLAIM_BLOCK flag and don't pick the process
> in select_bad_process.

A simpler solution may be to use sleep_on_interruptible, and
simply have the process continue into shrink_zone() if it
gets a signal.

-- 
All rights reversed.
