Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbZEESdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbZEESdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZEESdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:33:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZEESdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:33:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=k4E7lkHeUFojStxA2ue1KHx3YLEpEWlLcbQboXY55j3etV6sA/x+GPBnTE9BJA8fH
	s91AWMBbCbQ1IOoCnaxOw==
Date: Tue, 5 May 2009 11:33:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@android.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] oom: prevent possible OOM_DISABLE livelock
In-Reply-To: <20090505102250.GC28917@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0905051130120.26060@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com> <alpine.DEB.2.00.0905041726170.11756@chino.kir.corp.google.com> <20090505102250.GC28917@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Nick Piggin wrote:

> On Mon, May 04, 2009 at 05:27:07PM -0700, David Rientjes wrote:
> > It is currently possible to livelock the oom killer if a task is chosen
> > for oom kill and another thread sharing the same memory has an oom_adj
> > value of OOM_DISABLE.  This occurs because oom_kill_task() repeatedly
> 
> Hmm, but didn't the last patch make it a per-mm value?
> 

Yes, but this avoids taking task_lock(p) in select_bad_process() and moves 
all locking to badness().  It also introduces new behavior that anything 
with a badness score of 0 won't be killed, which wasn't explicit before 
(we relied on oom_kill_task() to reject it).
