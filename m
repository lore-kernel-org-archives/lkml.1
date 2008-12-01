Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYLAKfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYLAKfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLAKfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:35:05 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:52458 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbYLAKfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:35:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFAItGM0lMROB9/2dsb2JhbACBbcxvgn0
Date: Mon, 1 Dec 2008 05:35:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Trilok Soni <soni.trilok@gmail.com>, Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: keypad/touchscreen driver events latencies using LTTng on ARM?
Message-ID: <20081201103502.GC25340@Krystal>
References: <5d5443650811301000t58665a7j7aa93be52325a23b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <5d5443650811301000t58665a7j7aa93be52325a23b@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 05:28:54 up 14 days, 11:09,  2 users,  load average: 0.88, 0.48,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trilok Soni (soni.trilok@gmail.com) wrote:
> Hi,
> 
> I would like to try LTTng to measure the keypad and touchscreen
> drivers events latency on ARM based board, which typically runs less
> than 1GHz frequency.  I have recently tried LTTng patches as per
> compatibility list on LTTng website on 2.6.25 kernel on ARM11 based
> board, but on LTTv it shows the IRQ min/max interval times on
> nanoseconds precision, would that be correct? Because I thought it
> could be possible to microseconds format until with hrtimers support
> right? Just guide so that I can use this tool to effectively measure
> driver latencies. Thanks.
> 

Hi Trilok,

The current Trace Clock implementation uses the generic fallback in
include/asm-generic/trace-clock.h as a time source on ARM. It has a 1
jiffy precision and uses a logical clock in the least significant bits,
incremented a each event, to keep track of the event order. Therefore,
you should not rely on timing information more precise than 1 HZ.

However, I wonder if some of the newer ARM boards would happen to have a
cycle counter (timestamp counter), so we could implement a get_cycles()
and trace clock for them ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
