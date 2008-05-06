Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYEFFEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYEFFEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYEFFD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:03:58 -0400
Received: from ozlabs.org ([203.10.76.45]:36701 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYEFFD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:03:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] stop_machine: short exit path for if we cannot create enough threads
Date: Tue, 6 May 2008 12:57:05 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Kathy Staples <kathy.staples@au1.ibm.com>
References: <481678F5.7080504@jp.fujitsu.com> <481679F1.7010108@jp.fujitsu.com>
In-Reply-To: <481679F1.7010108@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <200805061257.05745.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008 11:29:21 Hidetoshi Seto wrote:
> stop_machine_run() invokes kthread 'kstopmachine' and the kthread
> creates its children for every other cpus.

Hi Hidetoshi,

   I'm glad to see some work on stop_machine!  I'd really like to rewrite it: 
it has some nasty properties at the moment and introduces latency it doesn't 
have to.

Among the properties we want in a new stop_machine are:
1) timeout protection (as your patches),
2) arbitrary cpumask for what cpus to run function on,
3) ability to run something other than cpu_relax() on stopped cpus,
4) much lower latency for the common case,
5) simpler than the current code.

I expect to get to this in the next week or so, but please remind me if you 
don't see anything.  I've applied your patches in the mean time (although #3 
needed to be wrapped in #ifdef CONFIG_STOPMACHINE) in case I don't get that 
work finished for 2.6.27.

Thanks!
Rusty.
