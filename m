Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYIWW44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYIWW44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYIWW4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:56:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3478 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYIWW4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:56:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:
	content-transfer-encoding:x-gmailtapped-by;
	b=o/TIKzmmxuCfLga/Se3t9enMc0DhsABN4Pv4DmR+LdTJS6N/l3F16jxrZnNT94Y6P
	2bsd2MHjiS54fO0kulwBQ==
Subject: Re: [PATCH 2.6.27-rc5 re-resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080923135917.GA285@tv-sign.ru>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu>
	 <1221502142.19012.35.camel@bobble.smo.corp.google.com>
	 <20080916084143.GC17287@elte.hu>
	 <1221678187.13420.17.camel@bobble.smo.corp.google.com>
	 <20080918102353.GD20967@elte.hu>
	 <1222114936.21579.20.camel@bobble.smo.corp.google.com>
	 <20080923114033.GB14840@elte.hu>  <20080923135917.GA285@tv-sign.ru>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 23 Sep 2008 15:56:00 -0700
Message-Id: <1222210560.3429.20.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 17:59 +0400, Oleg Nesterov wrote:
> Looks like task_delta_exec() forgets to unlock rq.

Actually it shouldn't be locking rq.  I failed to delete the lock.

> Confused. Unless I misread the patch, tgtimes->totals can be NULL
> on UP too?

Yeah.  I totally messed up on this, too many things going on at once.
I've eliminated the SMP/UP split in sched_stats.h and pulled it all into
the three basic functions.

> (of course, this can't explain the crash)

I'll be investigating this in the morning (I'm at home today and without
a test box).
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

