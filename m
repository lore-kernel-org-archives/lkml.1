Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbXJQSTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbXJQSTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbXJQSTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:19:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905AbXJQSTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:19:12 -0400
Date: Wed, 17 Oct 2007 11:18:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <20071017180042.GP15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171114320.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <alpine.LFD.0.999.0710171022340.26902@woody.linux-foundation.org>
 <20071017180042.GP15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
> > 
> > So avoiding the "sg_next()" on the last entry is pointless. 
> 
> Yeah, I didn't quite understand why if sg was valid, why dereferencing
> *(sg + 1)->page would crap out :/

Actually, I take that back. If 'sg' is the last entry in a *non*linked 
scatter-gather list (ie we don't use the last entry as a link, we actually 
use it as a real SG entry), then "sg_next(sg)" will indeed access past the 
end of the whole allocated array, and will access one past the end.

And with page-alloc debugging, that *will* blow up.

So I think your change to use "sg_next()" only when you actually need a 
next pointer is the correct one after all.

				Linus
