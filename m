Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZCJNoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZCJNoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZCJNoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:44:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51373 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbZCJNoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:44:04 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-aio@kvack.org, zach.brown@oracle.com, bcrl@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
	<20090309153630.912d36a0.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Mar 2009 09:43:56 -0400
In-Reply-To: <20090309153630.912d36a0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 9 Mar 2009 15:36:30 -0700")
Message-ID: <x49hc21bihv.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> It's risky to simply remove an existing tunable.  What if someone's
> mission-critical startup script which is provided by a super-slow or
> even no-longer-in-business vendor does 
>
> 	if (write(aoi-max-nr, something) == error)
> 		crash_and_burn()
>
> ?
>
> It would be prudent to have a more cautious update scheme.  Leave the
> existing tunable in place.  Keep it working if possible.  If someone
> uses it, blurt out a loud printk telling them that they're using a
> deprecated interface and informing them how to update.
>
> Then at some later time we can remove the old interface.

You are absolutely right.  The more I think about this, the less
enthused I am about it.  I still believe the change is the right way to
go, but there are years worth of deployments using the current scheme,
and there are existing documents detailing how to work within that
scheme.  I hereby rescind this patch.

I will follow-up with the memlock cleanup, though;  let me know if you
have comments on that patch.  Zach mentioned that he hates my new
function name (can_mlock_pages), so I guess at least that will change.
;)

Cheers,
Jeff
