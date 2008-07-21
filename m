Return-Path: <linux-kernel-owner+w=401wt.eu-S1760414AbYGUEae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414AbYGUEae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYGUEaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:30:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:49261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbYGUEaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:30:21 -0400
From: Neil Brown <neilb@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Date: Mon, 21 Jul 2008 14:30:12 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18564.4308.219240.133199@notabene.brown>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for
 all devices to init
In-Reply-To: message from Arjan van de Ven on Sunday July 20
References: <20080720151140.4aa7c682@infradead.org>
	<20080720151339.6f4a83d8@infradead.org>
	<18563.50428.659101.868745@notabene.brown>
	<20080720163126.64b39d50@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday July 20, arjan@infradead.org wrote:
> On Mon, 21 Jul 2008 09:06:36 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> >     if (driver_probe_done() != 0) {
> > 	printk("md: Waiting for all devices to be available before
> > autodetect\n" "md:  If you don't boot off raid, use
> > raid=noautodetect\n"); do
> 
> 
> how about this patch?

Well,

> -		while (driver_probe_done() != 0)
> +		printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
> +		printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");

that's better thanks.  I'm quite happy with that.


> +		while (driver_probe_done())
>  			msleep(100);

That's worse.  Now it really looks like a boolean that is being used
wrongly.  It seems that driver_probe_done either returns 0 or -EBUSY,
so I'd prefer

> +		while (driver_probe_done() < 0)
>  			msleep(100);

or even

> +		while (driver_probe_done() == -EBUSY)
>  			msleep(100);

though that is less robust.

Thanks,
NeilBrown
