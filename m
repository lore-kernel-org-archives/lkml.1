Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYGKSIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYGKSIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYGKSId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:08:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbYGKSId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:08:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: Linus Torvalds's message of  Friday, 11 July 2008 10:58:54 -0700 <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080710215039.2A143154218@magilla.localdomain>
	<20080711054605.GA17851@elte.hu>
	<alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
X-Windows: power tools for power losers.
Message-Id: <20080711180757.37CC9154213@magilla.localdomain>
Date: Fri, 11 Jul 2008 11:07:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		/* Only check signals if we have filled at least one entry! */
> +		if (signal_pending(current))
> +			return -EINTR;

Shouldn't it return the short count?  
(And if not, then probably should be -ERESTARTSYS.)


Thanks,
Roland
