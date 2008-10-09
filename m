Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYJIH75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYJIH75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbYJIH7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:59:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43142 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbYJIH7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:59:48 -0400
Date: Thu, 9 Oct 2008 10:06:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Andi Kleen <andi@firstfloor.org>,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rjw@sisk.pl, dipankar@in.ibm.com, tglx@linuxtronix.de
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Message-ID: <20081009080601.GD24560@one.firstfloor.org>
References: <20081009065529.GC24560@one.firstfloor.org> <48EDAD55.2000502@cn.fujitsu.com> <20081009161232.DEDC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009161232.DEDC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 04:14:26PM +0900, KOSAKI Motohiro wrote:
> Hi Lai-san,
> 
> > >> In this case, why not define it as:
> > >> static char buf[20*NR_CPUS + 100];
> > > 
> > > Actually you should near never use NR_CPUS now but always num_possible_cpus()
> > > (or even num_online_cpus()) Using NR_CPUS can lead to extreme waste
> > > of memory on kernels which are compiled for 4096 CPUs for example.
> > > 
> > > And with num_possible_cpus() kmalloc is needed.
> > 
> > I thought the default value of NR_CPUS is 32.
> 
> it's pointless.
> Almost distribution use _very_ large NR_CPUS (likes 4096).

Right now it's more like 8-128, but at least there is some effort
to make a 4096 CPU distribution possible and Mike Travis has been
 tirelessly working on eradicating all the rogue NR_CPUs all over 
the tree.  So it's better to not add more.

> So, We should concern large NR_CPUS.

Agreed.

-Andi

-- 
ak@linux.intel.com
