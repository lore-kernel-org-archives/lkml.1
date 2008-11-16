Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYKPXpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYKPXpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYKPXpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:45:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:58657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYKPXpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:45:12 -0500
Message-ID: <4920B069.5020203@kernel.org>
Date: Sun, 16 Nov 2008 15:44:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu>	 <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu>	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>	 <20081110094033.GL22392@elte.hu>	 <20081110015511.453a801e.akpm@linux-foundation.org>	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>	 <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu>	 <491C8B38.9060901@kernel.org>	 <20081113131850.d94fb229.akpm@linux-foundation.org> <1226869137.7178.175.camel@pasglop>
In-Reply-To: <1226869137.7178.175.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> 
> In any case, the patch is too big and unless I missed something, totally
> under-documented in what it does, why it does it, how it does it, etc...
> with a bit more of that, I might take more time to look closely and find
> out that indeed it's something I can make use of, maybe with a few
> tweaks.

will cut it to smaller ones. try to have one big one to make review more easy.

starting case
1. IBM x3950 have io apic pins > 224?
2. SGI big box need 8192 irqs 

want to make same kernel with NR_CPUS = 4096 can be used with regular sized system.

points are
1. removing irq_desc array and NR_IRQS. for small system will have less wasting ram in that array, and for big system will get more irqs like system have 8 pcie cards and every card need 40 MSI vector or a lot of IO apic controllers etc.
2. make irq number is bus/devfn/idx, and every dev func will use 12bit range, irq number is relatively fixed not like current MSI irq creating is some kind of floating from NR_IRQS too. 
3. irq_desc is going with /proc/irq/xxx/smp_affinity.

YH
