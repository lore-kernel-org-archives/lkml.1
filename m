Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYLBJGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYLBJGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 04:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYLBJGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 04:06:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbYLBJGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:06:17 -0500
Date: Tue, 2 Dec 2008 10:05:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] tracing/function-graph-tracer: support for x86-64
Message-ID: <20081202090556.GA12479@elte.hu>
References: <49347147.8070405@gmail.com> <20081202090205.GA11632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202090205.GA11632@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > This patch implements the support for function graph tracer under 
> > x86-64. Both static and dynamic tracing are supported.
> 
> Fantastic stuff! :-)

Graph tracer output from a 64-bit testbox:

 0)               |                cache_grow() {
 0)      0.323 us |                  _spin_lock();
 0)      0.314 us |                  kmem_flagcheck();
 0)               |                  kmem_getpages() {
 0)               |                    __alloc_pages_internal() {
 0)               |                      get_page_from_freelist() {
 0)      0.295 us |                        next_zones_zonelist();
 0)      0.306 us |                        next_zones_zonelist();
 0)      0.394 us |                        zone_watermark_ok();
 0)      0.415 us |                        _spin_lock_irqsave();
 0)               |                        __rmqueue() {
 0)               |                          __rmqueue_smallest() {
 0)      0.387 us |                            __mod_zone_page_state();
 0)      1.514 us |                          }
 0)      2.369 us |                        }
 0)               |                        zone_statistics() {
 0)      0.297 us |                          __inc_zone_state();
 0)      0.290 us |                          __inc_zone_state();
 0)      1.448 us |                        }
 0)      7.315 us |                      }
 0)      7.967 us |                    }
 0)               |                    mod_zone_page_state() {
 0)      0.285 us |                      __mod_zone_page_state();
 0)      0.931 us |                    }
 0)      9.993 us |                  }
 0)               |                  kmem_cache_alloc_node() {
 0)               |                    cache_alloc_refill() {

nice :)

	Ingo
