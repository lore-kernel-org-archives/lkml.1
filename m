Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbXGKIj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbXGKIj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbXGKIjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:39:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51055 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754375AbXGKIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:39:50 -0400
Message-ID: <46949751.1060701@sgi.com>
Date: Wed, 11 Jul 2007 10:39:45 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060527)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
Cc: Dmitry Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org,
       holt@sgi.com
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 9 Jul 2007, Dmitry Monakhov wrote:
>> Some device drivers can change vm_flags in their f_op->mmap
>> method. In order to be on the safe side we have to recheck
>> lock rlimit. Now we have to check lock rlimit from two places,
>> let's move this common code to helper functon.
>>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  mm/mmap.c |   33 ++++++++++++++++++++++++++-------
>>  1 files changed, 26 insertions(+), 7 deletions(-)
> 
> Or would this simpler patch be the right one?  I suspect the
> mspec driver only says VM_LOCKED because of a deep-seated but
> irrational fear that its pages might fall into reclaim.
> 
> (I'd like to take out VM_RESERVED too, but that can always happen
> another, indefinitely postponed time; there are others of those.)

Hi Hugh,

My mind is rusty on this one, so I checked with Robin Holt and his
is too .... most likely mspec has it for legacy problems, if your
change shows up to cause new problems, we'll fix them when they appear.
So from our side, it's fine to go ahead with this patch.

Cheers,
Jes
