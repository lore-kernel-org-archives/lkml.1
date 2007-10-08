Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbXJHLvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbXJHLvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbXJHLvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:51:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34291 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbXJHLvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:51:46 -0400
Date: Mon, 8 Oct 2007 13:51:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/6] scheduler: Protect important kernel threads
	against normalize_rt
Message-ID: <20071008115142.GE22199@elte.hu>
References: <200710071059.126674000@suse.de> <20071007205958.7D8C41474B@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007205958.7D8C41474B@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Not only the migration thread, but also softlockup and stop machine 
> need to be protected against normalize_rt(). Instead of checking for 
> them all I added a new process flag for this.

hm, i dont really like this. The migration thread is an absolute 
exception because it's needed for a correct scheduler. SysRq-N is like 
SysRq-U or SysRq-B - last-minute resort in case something Goes Foul. 
Results are not guaranteed.

	Ingo
