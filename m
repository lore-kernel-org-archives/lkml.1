Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYJIGtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYJIGtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYJIGtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:49:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50714 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYJIGtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:49:14 -0400
Date: Thu, 9 Oct 2008 08:55:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rjw@sisk.pl, dipankar@in.ibm.com, tglx@linuxtronix.de,
       andi@firstfloor.org
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Message-ID: <20081009065529.GC24560@one.firstfloor.org>
References: <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <48EDA2A6.9070707@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EDA2A6.9070707@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In this case, why not define it as:
> static char buf[20*NR_CPUS + 100];

Actually you should near never use NR_CPUS now but always num_possible_cpus()
(or even num_online_cpus()) Using NR_CPUS can lead to extreme waste
of memory on kernels which are compiled for 4096 CPUs for example.

And with num_possible_cpus() kmalloc is needed.

-Andi
