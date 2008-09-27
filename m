Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYI0Rvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYI0Rvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYI0Rmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:42:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbYI0Rms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:42:48 -0400
Date: Sat, 27 Sep 2008 19:42:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] - UV fix for size of hub mappings
Message-ID: <20080927174233.GB26047@elte.hu>
References: <20080925125210.GA22404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925125210.GA22404@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Fix the size of the mappings of UV hub registers. Size must be a 
> function of the maximum node number within the SSI.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>

applied to tip/x86/uv, thanks Jack!

i'm wondering, the code still has a couple of ZZZ fixmes like:

 #ifdef ZZZ              /* Needs x2apic patch */
 static void uv_send_IPI_self(int vector)
 {
         apic_write(APIC_SELF_IPI, vector);
 }
 #endif

x2apic support is available in tip/master, so it would be nice to glue 
UV to generic x2apic support properly and remove duplication and fixmes.
For example, do we really need apic_x2apic_uv_x, or could we use 
apic_x2apic_cluster?

	Ingo
