Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYJIHOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYJIHOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYJIHOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:14:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52453 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbYJIHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:14:29 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Cc: kosaki.motohiro@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rjw@sisk.pl, dipankar@in.ibm.com, tglx@linuxtronix.de
In-Reply-To: <48EDAD55.2000502@cn.fujitsu.com>
References: <20081009065529.GC24560@one.firstfloor.org> <48EDAD55.2000502@cn.fujitsu.com>
Message-Id: <20081009161232.DEDC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  9 Oct 2008 16:14:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai-san,

> >> In this case, why not define it as:
> >> static char buf[20*NR_CPUS + 100];
> > 
> > Actually you should near never use NR_CPUS now but always num_possible_cpus()
> > (or even num_online_cpus()) Using NR_CPUS can lead to extreme waste
> > of memory on kernels which are compiled for 4096 CPUs for example.
> > 
> > And with num_possible_cpus() kmalloc is needed.
> 
> I thought the default value of NR_CPUS is 32.

it's pointless.
Almost distribution use _very_ large NR_CPUS (likes 4096).
So, We should concern large NR_CPUS.


> 
> if NR_CPUS is too large, I think using seq_file is good idea,
> and rcuclassic_trace_mutex is not need too.


