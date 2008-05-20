Return-Path: <linux-kernel-owner+w=401wt.eu-S933708AbYETVDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708AbYETVDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760457AbYETVDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:03:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53359 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760194AbYETVC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:02:59 -0400
Date: Tue, 20 May 2008 14:02:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: blk_queue_bounce_limits can actually sleep
Message-ID: <20080520140241.1c7e018c@infradead.org>
In-Reply-To: <20080520195857.GC22369@kernel.dk>
References: <20080519202409.6d1055be@infradead.org>
	<20080520192958.GW22369@kernel.dk>
	<20080520124556.ad0c3fca.akpm@linux-foundation.org>
	<20080520195857.GC22369@kernel.dk>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 21:58:57 +0200
> Yeah, THAT I agree with in genereal, but it's probably too much here
> since most callers will not block and probably do call it under the
> queue lock already (just guessing here, didn't audit any callers).
> 
> > but it's all vague and waffly because Arjan forgot to tell us why
> > he's bothering to patch this code at all???
> 
> Probably the math still isn't quite correct, so it ends up setting up
> the isa pool for no good reason :-(
> 

well either it sleeps or it doesn't.....
if this guy should sleep (and right now it does) we shouldn't call it
from such contexts.
If we do the right thing and allocate the isa pools in a sane context,
it wouldn't ever sleep and the patch isn't needed...
