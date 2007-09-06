Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbXIFLfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbXIFLfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbXIFLfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:35:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbXIFLfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:35:04 -0400
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Paul McKenney <paulmck@us.ibm.com>
Subject: Re: Fast path efficiency (Re: [rfc][patch] dynamic data structure switching)
References: <20070902182738.GA13145@wotan.suse.de>
	<20070902183618.GB13145@wotan.suse.de> <E1IT3wK-0006Bh-22@flower>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Sep 2007 13:35:02 +0200
In-Reply-To: <E1IT3wK-0006Bh-22@flower>
Message-ID: <p73r6lc9gd5.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych <olecom@flower.upol.cz> writes:
> 
> What is more efficient in general sense,
> as opposed to s,3,2,1,0 Optimized?

In general it shouldn't matter at all on any reasonably 
modern CPU (let's say less than 10 years old) unless you do
it tens of thousands of times in a loop. Also gcc has reasonable
default heuristics for this kind of stuff anyways
(e.g. return NULL or return negative value is predicted
unlikely by default) 

Cache misses are far more important to care about because
they cost hundreds of cycles.

-Andi
