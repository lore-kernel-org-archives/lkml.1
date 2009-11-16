Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZKPSox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZKPSox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZKPSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:44:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:56083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbZKPSow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:44:52 -0500
Message-ID: <4B019D40.4010108@kernel.org>
Date: Tue, 17 Nov 2009 03:43:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Subject: Re: [PATCH 04/21] sched: implement scheduler notifiers
References: <1258391726-30264-1-git-send-email-tj@kernel.org> <1258391726-30264-5-git-send-email-tj@kernel.org> <4B019A76.2080706@redhat.com>
In-Reply-To: <4B019A76.2080706@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Avi Kivity wrote:
> Four hlist_heads (64 bytes) is pretty heavy for this.

hlist_head is one pointer, so it will be 32bytes on 64bit machines.

> I having all members present in sched_notifier (instead of a union)
> and calling a callback if it is not NULL.  This reduces the overhead
> to 16 bytes at the expense of an extra check for sched_notifier
> users.

And it will reduce the overhead to 8 bytes.  Anyways, Linus was
against walking the list multiple times for different callbacks and
the way kvm uses these notifiers doesn't work very well with
allocating separate table on demand, so I just went with four
pointers.  Given that these notifiers are quite unpopular yet, I lean
toward Avi's suggestion.  Linus?

> Besides this, is there any difference to preempt_notifiers?  if not we
> can just add the new members and rename.

Yeap, if we're gonna add things to ops table, I agree that would be
better.

Thanks.

-- 
tejun
