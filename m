Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbXCZKMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbXCZKMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXCZKMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:12:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXCZKMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:12:38 -0400
Date: Mon, 26 Mar 2007 12:11:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       auke-jan.h.kok@intel.com, Adrian Bunk <bunk@stusta.de>
Subject: -rc5: e1000 resume weirdness
Message-ID: <20070326101153.GA4593@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
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


hm, on a T60, after suspend/resume, i get an e1000 timeout:

e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
  Tx Queue             <0>
  TDH                  <ec>
  TDT                  <ec>
  next_to_use          <ec>
  next_to_clean        <82>
buffer_info[next_to_clean]
  time_stamp           <fffcc3db>
  next_to_watch        <82>
  jiffies              <fffd5da0>
  next_to_watch.status <1>

it works fine after that reset. The e1000 driver didnt do this before 
after resume the network was always available immediately. So this 
appears to be a relatively new regression (post-rc3 or so). high-res 
timers was disabled.

	Ingo
