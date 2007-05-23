Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbXEWWcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbXEWWcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbXEWWcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:32:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41023 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756306AbXEWWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:32:38 -0400
Date: Wed, 23 May 2007 15:32:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <441277.33537.qm@web52606.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705231528170.22666@schroedinger.engr.sgi.com>
References: <441277.33537.qm@web52606.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Srihari Vijayaraghavan wrote:

> I'm stunned. Honestly, I have no possible explanations for this behaviour. Do
> you? I need more time to work out (until otherwise you might know a reason).

Hmmm... Bad. We have conflicting reports and no clear way to trigger the 
bug. This may actually only trigger depending on how certain objects is 
place in memory.

Could you boot with slub_debug and then run

slabinfo -v

to validate all slabs? If there is anything wrong with an object then it 
should show in the syslog.

slabinfo.c can be found at Documentation/vm/slabinfo.c
 
> Oh, while at it, I created this patch (to ask you more info on what
> slub_nomerge is for):

See Documentation/vm/slub.txt which covers most of those.

slub_nomerge is not mentioned. It removes an optimization and that is only 
useful for debugging strange cornercases. I hope to remove it someday.

