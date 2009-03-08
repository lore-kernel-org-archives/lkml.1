Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZCHKQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZCHKQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZCHKQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:16:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46074 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZCHKQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:16:19 -0400
Date: Sun, 8 Mar 2009 11:15:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, linux-pci@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] pci: fix kexec with power state D3
Message-ID: <20090308101530.GB14133@elte.hu>
References: <49B1F934.5050006@kernel.org> <4807377b0903062318q15ba52a7n82d4c9399b8a7fa8@mail.gmail.com> <49B37D38.7060304@kernel.org> <200903081108.24541.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903081108.24541.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Sunday 08 March 2009, Yinghai Lu wrote:
> > 
> > Impact: second kernel by kexec will have some pci devices working
> > 
> > Found one system with 82575EB, in the kernel that is kexeced, probe igb
> > failed with -2.
> > 
> > it looks like the same behavior happened on forcedeth.
> > try to check system_state to make sure if put it on D3
> 
> This is not enough, because the PM code doesn't change 
> system_state and it uses pci_set_power_state too.
> 
> > Jesse Brandeburg said that we should do that check in core 
> > code instead of every device driver.
> 
> Well, I'm not really sure.  The drivers are where the bug is.

So Yinghai has now written a driver fix and a generic code fix 
as well and both are being rejected pointing to the other side? 

This really sucks for users (who'd be happy with any of the 
patches) and the disagreement needs to be resolved ASAP.

	Ingo
