Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbZKBSJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbZKBSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbZKBSJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:09:58 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47635 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbZKBSJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x/Jwx2tV48/LZoDU6ZaLvGKCXrR15qXBLeTpecLBtzb605j7jJV+kOguZ11eZkQvaP
         1o5pNCGdekV1iSlVCLJeQ0xQKriiRzdFdwghWMLwwmBvbG+JjIV9YRIwXHpMXJbuTl0Z
         4Q4yC3NDFbpdwKjoHrOnlTp8WjrNQ80h+ak/M=
Date: Mon, 2 Nov 2009 21:09:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch][rfc] x86, mutex: non-atomic unlock (and a rant)
Message-ID: <20091102180959.GC10072@lenovo>
References: <20091102120739.GA20318@wotan.suse.de> <alpine.LFD.2.01.0911020710030.31845@localhost.localdomain> <20091102164626.GA10072@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102164626.GA10072@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Nov 02, 2009 at 07:46:26PM +0300]
| 
| The other option could be that we put two mem-write operations
| like
| 	int tmp;
| 	atomic_set(&lock->count, 1);
| 	tmp = lock->waiters;
| 	rmb();
| 	lock->waiters = tmp;
| 	if (unlikely(lock->waiters))
| 		fail_fn(lock);
| 
| Which should work faster then cpuid (and we have to be sure somehow
| that gcc doesn't suppress this redundant operations).
|

And which has nothing to do with OoO mem-read, and wouldn't
work. Sorry for noise.
 
	-- Cyrill
