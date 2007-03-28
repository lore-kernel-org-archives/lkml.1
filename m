Return-Path: <linux-kernel-owner+w=401wt.eu-S1750874AbXC1NEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874AbXC1NEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbXC1NEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:04:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbXC1NEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:04:11 -0400
Date: Wed, 28 Mar 2007 15:03:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Meyer <thomas@m3y3r.de>, Frederic Riss <frederic.riss@gmail.com>,
       Marcus Better <marcus@better.se>
Subject: Re: [4/5] 2.6.21-rc5: known regressions
Message-ID: <20070328130326.GA27126@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015949.GB16477@stusta.de> <20070328121958.GA11290@elte.hu> <20070328124121.GA23564@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328124121.GA23564@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> PM: Writing back config space on device 0000:15:00.0 at offset 4 (was 0, writing e4300000)
> PM: Writing back config space on device 0000:15:00.0 at offset 3 (was 20000, writing 2a820)
> PM: Writing back config space on device 0000:15:00.0 at offset 1 (was 2100000, writing 2100007)
> system 00:00: resuming <-------------- [ hard hang ]
> pnp 00:01: resuming
> system 00:02: resuming
> pnp 00:03: resuming

ok, this was a red herring: the hard hang was an effect of netconsole 
combined with CONFIG_DISABLE_CONSOLE_SUSPEND. Disabling netconsole 
solved it. I'll now re-test Eric's MSI patch.

	Ingo
