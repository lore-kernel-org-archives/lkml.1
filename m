Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbYCUQdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbYCUQdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYCUQdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:33:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40172 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYCUQdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:33:14 -0400
Date: Fri, 21 Mar 2008 17:32:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] forcedeth: fix locking bug with netconsole
Message-ID: <20080321163252.GA1034@elte.hu>
References: <20080321155213.GA22755@elte.hu> <47E3DDD1.2010601@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3DDD1.2010601@pobox.com>
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


* Jeff Garzik <jgarzik@pobox.com> wrote:

> Ingo Molnar wrote:
>> Subject: forcedeth: fix locking bug with netconsole
>> From: Ingo Molnar <mingo@elte.hu>
>>
>> while using netconsole on forcedeth, lockdep noticed the following
>> locking bug:
> [...]
>> the fix is to disable/restore irqs instead of disable/enable.
>
> So we make _the_ TX fast path slower, to accomodate a path that is 
> rarely executed?

no strong opinion but a single PCI mmio access far outweighs any flags 
save/restore, so i'd not fight about something like that. I've never 
seen flags save/restore costs show up in NMI-driven profiles that had 
networking load.

	Ingo
