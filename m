Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0CBLlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:41:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:33125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0CBLlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:41:22 -0500
Subject: Re: [PATCH] perf_events: add sampling period randomization support
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
In-Reply-To: <20100302105314.GF13205@erda.amd.com>
References: <1267510029-19750-1-git-send-email-eranian@google.com>
	 <20100302105314.GF13205@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 12:41:18 +0100
Message-ID: <1267530078.25158.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 11:53 +0100, Robert Richter wrote:
> 
> Only adding the random value will lead to longer sample periods on
> average. To compensate this you could calculate something like:
> 
>          event->hw.sample_period = event->attr.sample_period + (new_seed & mask) - (mask >> 1);

Or cheat and do something like:

  sample_period ^= (new_seed & mask);

