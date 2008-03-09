Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYCIMBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYCIMBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYCIMBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:01:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYCIMBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:01:41 -0400
Date: Sun, 9 Mar 2008 13:01:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080309120124.GB1249@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <alpine.LFD.1.00.0803091244420.3099@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803091244420.3099@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Right, also the quicklist_trim() in idle() is freeing at max 16 pages 
> in one go. According to the quicklist_trim() code we keep up to 
> (node_free_pages / 16) in the quicklist unconditionally, which seems 
> rather odd as well.

i suspect the right approach would be to get rid of them altogether and 
to convert the code to RCU and plain old alloc/free instead.

	Ingo
