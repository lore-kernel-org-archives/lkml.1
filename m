Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXFSTGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXFSTGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932438AbXFSTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:05:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42400 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932395AbXFSTFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:05:20 -0400
Date: Tue, 19 Jun 2007 12:04:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stoffel <john@stoffel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, tim.c.chen@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: Change in default vm_dirty_ratio
In-Reply-To: <18040.9056.755569.67029@stoffel.org>
Message-ID: <alpine.LFD.0.98.0706191201130.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
 <20070618164711.9de1c38e.akpm@linux-foundation.org>
 <18040.9056.755569.67029@stoffel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Jun 2007, John Stoffel wrote:
> 
> Shouldn't the vm_dirty_ratio be based on the speed of the device, and
> not the size of memory?

Yes. It should depend on:
 - speed of the device(s) in question
 - seekiness of the workload
 - wishes of the user as per the latency of other operations.

However, nobody has ever found the required algorithm.

So "at most 10% of memory dirty" is a simple (and fairly _good_) 
heuristic. Nobody has actually ever ended up complaining about the change 
from 40% -> 10%, and as far as I know this was the first report (and it's 
not so much because the change was bad, but because it showed up on a 
benchmark - and I don't think that actually says anythign about anything 
else then the behaviour of the benchmark itself)

So are there better algorithms in theory? Probably lots of them.

		Linus
