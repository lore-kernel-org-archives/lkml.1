Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXEGK4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXEGK4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXEGK4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:56:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40721 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbXEGK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:56:12 -0400
Date: Mon, 7 May 2007 19:56:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, vatsa@in.ibm.com,
       zwane@arm.linux.org.uk, nathanl@austin.ibm.com, jschopp@austin.ibm.com,
       ashok.raj@intel.com, heiko.carstens@de.ibm.com,
       takeuchi_satoru@jp.fujitsu.com
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty realtime
 processes
Message-Id: <20070507195648.dafe57b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2007 19:10:05 +0900
Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:


> kstopmachine is created, bound to the CPU1, and woken up here, but
> this process can't start to run because reschedule doesn't occur on
> CPU1. Hence CPU0 also be able to run because it's waiting completion
> of CPU1's offline work.
> 
Is this Bug ? It seems the system works as designed... 

Hmm,  adding stop_machine_run_interruptible() and 
using wait_for_completion_interruptible() instead of wait_for_completion()
is O.K. ? Then we can stop cpu hot-unplug by signal. Is this okay for you ?

-Kame

