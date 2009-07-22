Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZGVVHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZGVVHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZGVVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:07:13 -0400
Received: from www.tglx.de ([62.245.132.106]:53655 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZGVVHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:07:12 -0400
Date: Wed, 22 Jul 2009 23:07:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Fix compile failure after genirq: Delegate irq affinity
 setting to the irq thread
In-Reply-To: <20090722222232.2eb3e1c4@neptune.home>
Message-ID: <alpine.LFD.2.00.0907222305530.2813@localhost.localdomain>
References: <20090722222232.2eb3e1c4@neptune.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-424348811-1248296826=:2813"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-424348811-1248296826=:2813
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 22 Jul 2009, Bruno Prémont wrote:

> Since genirq: Delegate irq affinity setting to the irq thread
> (591d2fb02ea80472d846c0b8507007806bdd69cc) compilation with
> CONFIG_SMP=n fails with following error:
> 
> /usr/src/linux-2.6/kernel/irq/manage.c:
>    In function 'irq_thread_check_affinity':
> /usr/src/linux-2.6/kernel/irq/manage.c:475:
>    error: 'struct irq_desc' has no member named 'affinity'
> make[4]: *** [kernel/irq/manage.o] Error 1
> 
> That commit adds a new function irq_thread_check_affinity() which
> uses struct irq_desc.affinity which is only available for CONFIG_SMP=y.
> Move that function under #ifdef CONFIG_SMP.
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>

Darn. My bad. I was too focussed to get that problem solved :(

Thanks,

	tglx
--8323328-424348811-1248296826=:2813--
