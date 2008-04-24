Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbYDXOQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbYDXOQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYDXOP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:15:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33126 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYDXOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:15:56 -0400
Message-ID: <4810961A.4000104@firstfloor.org>
Date: Thu, 24 Apr 2008 16:15:54 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <87ve27gz4u.fsf@basil.nowhere.org> <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk>
In-Reply-To: <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Not a good idea IMHO, it's much better with an explicit setting. That
> way you don't introduce indeterministic behavior.

So you would be deterministically slower.

Another way to avoid this problem would be to keep the statistics per
IO context, then the same run of a program would always get the same
behaviour. Drawback is that if your non mergeable workload consists of
lots of short running processes (like a shell script) the optimization
wouldn't work. Not sure if it's really practical, but it would be an option.

I think in modern systems with caches etc. you typically have enough
non quite deterministic and other surprising and hard to analyze
behaviour anyways, so a little more doesn't make much difference.

-Andi



