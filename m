Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYDGTo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYDGTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYDGToW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:44:22 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:24129 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbYDGToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:44:21 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: bootmem allocator
From: Andi Kleen <andi@firstfloor.org>
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu>
Date: Mon, 07 Apr 2008 21:44:04 +0200
In-Reply-To: <20080407190904.GH12292@elte.hu> (Ingo Molnar's message of "Mon, 7 Apr 2008 21:09:04 +0200")
Message-ID: <87iqytqwl7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Apr 2008 19:37:21.0357 (UTC) FILETIME=[CC1027D0:01C898E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> Hi Ingo, Peter,
>> 
>> small question. It was a patch recently posted which removes memset(x, 
>> 0, x) after __alloc_bootmem call. There are a few another code 
>> snippets who still call memset(x, 0, x). And who is responsible for 
>> memory clearing? bootmem allocator or caller?
>
> hm, bootmem allocator is supposed to clear memory. We have a couple of 
> places that rely on that.

I was actually considering to change that for the GB pages hugetlbfs
patchkit, because memset for 1G is a little slow and not needed (will be cleared later
anyways) and it might be a problem for very large systems with a lot of such
pages at boot.

-Andi
