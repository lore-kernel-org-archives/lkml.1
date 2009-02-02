Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZBBIxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZBBIxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 03:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbZBBIxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 03:53:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZBBIxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 03:53:42 -0500
Subject: Re: hackbench [pthread mode] regression with 2.6.29-rc3
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1233537134.2604.24.camel@ymzhang>
References: <1233473426.2604.13.camel@ymzhang>
	 <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com>
	 <1233476961.13659.12.camel@minggr.sh.intel.com>
	 <1233479836.4787.63.camel@laptop>  <1233482239.4787.65.camel@laptop>
	 <1233537134.2604.24.camel@ymzhang>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 09:53:38 +0100
Message-Id: <1233564818.4787.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 09:12 +0800, Zhang, Yanmin wrote:

> process timer (by setitimer) isn't good. Is per-cpu itimer to improve it?

> So the per-cpu itimer could improve this situation when thread number is far bigger than
> cpu number. I didn't retry specweb2005 with 2.6.28.

1) process wide itimers are rubbish, 2) per-cpu itimers are rubbish too,
for the very simple reason they waste gobs of memory for sane programs.

I would rather go back to the old model where we iterate all threads,
and find a way to not make programs with too many threads for their own
good lock up the kernel, but instead get poor service.

Now the problems appears to be that I overlooked that we keep the itimer
clock running at all times, not only when we have a pending timer, and I
suppose that the standard mandates that behaviour :/

Anyway, I will try to sort something out, at worst we'll have to revert
to the .28 state and live with the per-cpu crap for another release.

