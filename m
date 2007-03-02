Return-Path: <linux-kernel-owner+w=401wt.eu-S1030500AbXCBVyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030500AbXCBVyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030503AbXCBVyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:54:10 -0500
Received: from gw.goop.org ([64.81.55.164]:58579 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030500AbXCBVyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:54:08 -0500
Message-ID: <45E89CFB.4090905@goop.org>
Date: Fri, 02 Mar 2007 13:54:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tim.c.chen@linux.intel.com
CC: linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: system call time increase when turning on CONFIG_PARAVIRT
References: <1172866274.4898.14.camel@localhost.localdomain>
In-Reply-To: <1172866274.4898.14.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> With CONFIG_PARAVIRT turned on, I've found that time invoking
> system_call jumped up quite a lot.  Using TCP streaming test as a
> workload and running on 32-bit 2.6.20 kernel, system_call goes up from
> 0.00025% all the way to 1.6% in the oprofile data.  There is a drop of
> about 4% in overall throughput for this particular workload. 
>
> With lmbench's null system call test, the call time goes up from 0.10
> usec to 0.225 usec.
>
> I'm testing on dual socket Intel core 2 processor running at 2.67 GHz
> with 4 GB RAM.
[ I assume you're talking about running on native hardware. ]

In the current paravirt changes in the kernel, many of the
paravirtualized operations are implemented as (expensive) indirect calls
via paravirt_ops.  Among the changes in the paravirt patches I posted
yesterday is an enhanced patching mechanism which inlines a lot of the
common operations, and converts the rest into direct calls.

I haven't done any detailed measurements on what effect this will have,
but it does bring the actual executed instruction stream much closer to
the !CONFIG_PARAVIRT case, and so I would hope it would recover most or
all of the performance loss you've noticed.

    J
