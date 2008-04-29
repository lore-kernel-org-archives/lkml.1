Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYD2G7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYD2G7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYD2G7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:59:23 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:53186 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753685AbYD2G7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:59:23 -0400
Subject: Re: [BUG-REPORT] hrtick_start_fair and CPU-Hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: ego@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080429065211.GB7859@in.ibm.com>
References: <20080429065211.GB7859@in.ibm.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 08:59:19 +0200
Message-Id: <1209452359.13978.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 12:22 +0530, Gautham R Shenoy wrote:
> Hello!
> 
> While running the usual CPU-Hotplug stress tests on linux-2.6.25,
> I noticed the following in the console logs.
> 
> This is a wee bit difficult to reproduce. In the past 10 runs I hit this
> only once.
> 
> ------------[ cut here ]------------
> 
> WARNING: at kernel/sched.c:962 hrtick+0x2e/0x65()

> I am not well versed with this part of the code, so just wondering if we
> are doing a good job at handling the cancellation of any per-cpu
> scheduler timers during CPU-Hotplug.

This looks like its not cancelled at all and migrates the it to another
cpu. I'll see what I can come up with.

