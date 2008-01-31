Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbYAaNZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbYAaNZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761300AbYAaNY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:24:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759285AbYAaNY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:24:56 -0500
Date: Thu, 31 Jan 2008 14:24:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/4] x86_64: increse MAX_EARLY_RES for NODE_DATA and
	bootmap
Message-ID: <20080131132438.GC8499@elte.hu>
References: <200801291113.35974.yinghai.lu@sun.com> <200801291116.31729.yinghai.lu@sun.com> <200801300357.54924.ak@suse.de> <200801291925.53726.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801291925.53726.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> ok, discard 3, and 4.
> 
> how about 2 v2?

i'm leaning towards v4, but the more fundamental breakage is in the 
early_node_mem() ad-hoc allocator that got butchered into this code a 
year ago:

  commit a8062231d80239cf3405982858c02aea21a6066a
  Author: Andi Kleen <ak@suse.de>
  Date:   Fri Apr 7 19:49:21 2006 +0200

      [PATCH] x86_64: Handle empty PXMs that only contain hotplug memory

  ...
  +static void * __init
  +early_node_mem(int nodeid, unsigned long start, unsigned long end,
  +             unsigned long size)

and we are now suffering the side-effects of that hack.

what i suspect we need instead is a proper early-allocator that works in 
the e820 space.

	Ingo
