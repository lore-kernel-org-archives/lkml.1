Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753615AbYLRVRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYLRVRF (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYLRVQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:16:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43290 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYLRVQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:16:51 -0500
Date: Thu, 18 Dec 2008 22:16:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer
	interrupt infinite loop
Message-ID: <20081218211637.GF24271@elte.hu>
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu> <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain> <20081218112216.GE14332@elte.hu> <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Hmm. No, I just tested by setting 1000 HZ and disabled NOHZ, the system 
> doesn't lockup unless I turn on the function graph tracer.

but that's what we are interested in: the system locks up with HZ=1000 and 
with the tracer on - right?

Which means that it's not some hrtimer problem, but simply the traced 
timer tick takes more than 1 millisecond to execute under this 
virtualization.

	Ingo
