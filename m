Return-Path: <linux-kernel-owner+w=401wt.eu-S934925AbYD1Onx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925AbYD1Onx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbYD1Onm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:43:42 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41042 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106AbYD1Onk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:43:40 -0400
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <18470.1209392727@redhat.com>
References: <1209219236.3113.6.camel@localhost.localdomain>
	 <1208890227-24808-1-git-send-email-jens.axboe@oracle.com>
	 <1208890227-24808-2-git-send-email-jens.axboe@oracle.com>
	 <20080425231100.b93a1601.akpm@linux-foundation.org>
	 <18470.1209392727@redhat.com>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 10:43:32 -0400
Message-Id: <1209393812.3367.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 15:25 +0100, David Howells wrote:
> We could use a GOT, but I believe that would add an extra memory
> access to any
> memory access or jump - which I'd prefer to avoid.

Not necessarily; this is how we work on PARISC with a GOT as the ELF
spec defines.  The point is that the GOT is linker constructed, so we
only lay down GOT entries when the linker sees that relative
displacements fail, so they don't consume memory (or even get brought
into existence) in the ordinary case.  The flip side of this is that we
do double jump (relative to jump through got) for the long displacements
we can't reach.

James


