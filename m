Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbZANKs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbZANKs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZANKsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:48:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557AbZANKsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:48:37 -0500
Date: Wed, 14 Jan 2009 11:48:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mbligh@google.com,
       thockin@google.com
Subject: Re: [PATCH] softlock: fix false panic which can occur if
	softlockup_thresh is reduced
Message-ID: <20090114104826.GF2913@elte.hu>
References: <20090113051517.GA27227@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113051517.GA27227@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mandeep Singh Baines <msb@google.com> wrote:

> At run-time, if softlockup_thresh is changed to a much lower value,
> touch_timestamp is likely to be much older than the new softlock_thresh.
> 
> This will cause a false softlockup to be detected. If softlockup_panic
> is enabled, the system will panic.
> 
> The fix is to touch all watchdogs before changing softlockup_thresh.
> 
> Signed-off-by: Mandeep Singh Baines <msb@google.com>
> ---
>  include/linux/sched.h |    3 +++
>  kernel/softlockup.c   |    9 +++++++++
>  kernel/sysctl.c       |    2 +-
>  3 files changed, 13 insertions(+), 1 deletions(-)

applied to tip/core/urgent, thanks!

	Ingo
