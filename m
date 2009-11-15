Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZKOK3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZKOK3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZKOK3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:29:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59678 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZKOK3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:29:01 -0500
Date: Sun, 15 Nov 2009 11:28:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v3] perf tools: New function to parse string representing
 size in bytes
Message-ID: <20091115102859.GA24931@elte.hu>
References: <20091115.185220.212229853.mitake@dcl.info.waseda.ac.jp>
 <1258280343-4359-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258280343-4359-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> + * bytesexp2int()

i suspect this could be named 'bytestring2ll' ? Is 'bytesexp' an 
existing naming in other libraries?

> + * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB|tb|TB) (e.g. "256MB")
> + * and return its numeric value
> + */
> +long long int bytesexp2int(const char *str)

we have type shortcuts for 'long long': s64.

> +{
> +	unsigned int i;
> +	long long int length = -1, unit = 1;

s64 too i suspect.

> +tera:
> +			unit = (long long int)K * K * K * K;

Note, you can probably avoid this type cast if you define the 'K' 
literal as 1024LL or so.

> +	length = atoll(str) * unit;

we might want to take a naming clue here and name this new function as 
atoll_exp(), to signal that it works like atoll, just with an extension 
for KB/MB/GB/etc. expressions?

	Ingo
