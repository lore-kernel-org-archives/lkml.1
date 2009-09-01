Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZIAQJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZIAQJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZIAQJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:09:36 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:27477 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZIAQJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:09:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPzjnEqrR7PD/2dsb2JhbADEfYhBAZAFBYQb
X-IronPort-AV: E=Sophos;i="4.44,313,1249257600"; 
   d="scan'208";a="235889062"
From: Roland Dreier <rdreier@cisco.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/1] introduce __cancel_delayed_work()
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com>
	<adaab1sx29p.fsf@cisco.com> <20090824180112.GC16202@redhat.com>
	<ada4orwvrx7.fsf@cisco.com> <20090825093906.GA3020@redhat.com>
	<ada7hwqto0z.fsf@cisco.com> <20090828175931.GA19326@redhat.com>
	<20090828180015.GB19326@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 01 Sep 2009 09:09:36 -0700
In-Reply-To: <20090828180015.GB19326@redhat.com> (Oleg Nesterov's message of
	"Fri, 28 Aug 2009 20:00:15 +0200")
Message-ID: <ada1vmqpry7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Sep 2009 16:09:37.0111 (UTC) FILETIME=[9A4B2670:01CA2B1E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > cancel_delayed_work() has to use del_timer_sync() to guarantee the
 > timer function is not running after return. But most users doesn't
 > actually need this, and del_timer_sync() has problems: it is not
 > useable from interrupt, and it depends on every lock which could
 > be taken from irq.
 > 
 > Introduce __cancel_delayed_work() which calls del_timer() instead.
 > 
 > The immediate reason for this patch is
 > http://bugzilla.kernel.org/show_bug.cgi?id=13757
 > but hopefully this helper makes sense anyway.

Thanks, Oleg!

Andrew -- how do you want to handle this?  This seems to be useful for
the bug with IB that Oleg linked to, as well as by Dmitry in input, so
I'm not sure what the best way to merge all this into 2.6.32 is.

I could take Oleg's patch and the corresponding fix to
drivers/infiniband through my tree, and merge as early I as I see Linus
open 2.6.32.  That leaves Dmitry to wait on it (and possibly causes
problems in -next with tree ordering) though.  But I don't see any way
to get the number of cross-tree dependencies below 1... (unless maybe
Dmitry can take the identical workqueue patch into his tree and trust
git to sort it out?)

 - R.
