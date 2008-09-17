Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbYIQHkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbYIQHkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 03:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYIQHkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 03:40:06 -0400
Received: from main.gmane.org ([80.91.229.2]:43748 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbYIQHkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 03:40:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andrew Paprocki <andrew@ishiboo.com>
Subject: Re: [RFC PATCH 0/1]: timers: Timer Migration
Date: Wed, 17 Sep 2008 07:35:04 +0000 (UTC)
Message-ID: <loom.20080917T072423-185@post.gmane.org>
References: <20080916091219.GA1068@linux.vnet.ibm.com> <1221566730.6943.16.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 76.15.153.58 (Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.15; .NET CLR 3.5; ffco7) Gecko/20080623 Firefox/2.0.0.15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra <at> chello.nl> writes:

> This seems like an exceedingly dumb idea - cpu 0 might be a long long
> way from x and by pushing all timers to cpu0 you might actually overload
> cpu 0.

You have to give credit to Solaris for doing that first :). They implemented
usleep() using nanosleep() which uses the kernel callout queue. That queue is
single threaded and only processed on CPU0 in the clock interrupt handler,
causing CPU0 to spin 100% if enough calls to usleep() are made across the system.

http://bugs.opensolaris.org/view_bug.do?bug_id=6565503

-Andrew

