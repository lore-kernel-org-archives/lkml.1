Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbYEFNQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbYEFNQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbYEFNQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:16:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54863 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbYEFNQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:16:45 -0400
Date: Tue, 6 May 2008 15:16:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: kgdboe?
Message-ID: <20080506131632.GD2146@elte.hu>
References: <481EFE69.20308@windriver.com> <200805051110.32238.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805051110.32238.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> So when will we see kgdboe or some other way of getting gdb to connect 
> to the target over ethernet upstream?

i think the proper way would be to extend the kgdb-over-console (kgdboc) 
concept and make it easy to utilize the existing netconsole code via 
KGDB. This brings nice synergy: netconsole is utilized by other debug 
infrastructure as well so anything that supports netconsole would 
automatically support KGDB as well. I dont really like the old kgdboe 
approach from a design POV as it created a parallel infrastructure for 
special-purpose kgdb IO.

likewise, the firewire debugging code could/should be extended to create 
a bidirectional console as well - that has other benefits as well. (we'd 
get printks over firewire - instead of the special-purpose firescope 
utility)

and the early console drivers could be reused to do early debugging via 
KGDB as well.

	Ingo
