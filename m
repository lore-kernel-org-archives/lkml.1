Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbYABQqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbYABQqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbYABQq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:46:29 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40644 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083AbYABQq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:46:28 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080102162534.GA4041@elte.hu>
References: <20080102162534.GA4041@elte.hu>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 10:46:21 -0600
Message-Id: <1199292381.3258.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 17:25 +0100, Ingo Molnar wrote:
> revert commit:
> 
>   commit 6f5391c283d7fdcf24bf40786ea79061919d1e1d
>   Author: Matthew Wilcox <matthew@wil.cx>
>   Date:   Tue Sep 25 12:42:04 2007 -0400
> 
>       [SCSI] Get rid of scsi_cmnd->done
> 
> this is a supposed-to-be-cleanup commit, but apparently it causes
> regressions:
> 
>   Bug 9370 - v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
>   http://bugzilla.kernel.org/show_bug.cgi?id=9370
> 
> this patch should be reintroduced in a more split-up form to make
> testing of it easier.

I disagree with this.  We only have one reporter of a problem and it
appears to be some type of obscure interaction with pktdvd which no-one
can track down (although it's not really helped by the reporter not
being very responsive).

The correct thing to do is root cause the problem and fix it at source,
since it's very likely that this is a pre-existing bug that was simply
uncovered by the patch you're recommending we revert.

Unfortunately, I suspect it won't get fixed until someone else actually
manages to reproduce it (which I haven't been able to so far).

James


