Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZC1TMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZC1TMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZC1TM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:12:27 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:32929 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZC1TM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V8/qMTx3G1jgcgufGubgn7KL5vHDudXRCtWnKuMC8ZyUN6/oaO/tuGMDt78XrXOXdt
         uh2O+8GYImj2cYEDFpKKcFVM8f5Emp5z0i2p666dMfOYKzhmjhYbayJjK8LdHWytg69v
         HcIEwTveDJHySmp3U6sbOsFyb6TM/FY7Zl9U8=
Message-ID: <49CE7688.2020501@gmail.com>
Date: Sat, 28 Mar 2009 20:12:08 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, eteo@redhat.com,
       linux-usb@vger.kernel.org, netdev@vger.kernel.org,
       linux-media@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: Dereferencing freed memory bugs
References: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
In-Reply-To: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> I added a check to smatch (http://repo.or.cz/w/smatch.git/) to check
> for when we dereference
> freed memory.
> 
> drivers/dma/dmatest.c +410 dmatest_exit(7) 'dtc'
> drivers/dma/dmatest.c +412 dmatest_exit(9) 'dtc'

Seems to be fixed by 7cbd4877e5b167b56a3d6033b926a9f925186e12:
dmatest: fix use after free in dmatest_exit

> drivers/infiniband/hw/nes/nes_cm.c +563 nes_cm_timer_tick(121) 'cm_node'
> drivers/infiniband/hw/nes/nes_cm.c +621 nes_cm_timer_tick(179) 'cm_node'
> (...)
> drivers/usb/host/ehci-hcd.c +1661 itd_complete(79) 'stream'
> drivers/usb/host/ehci-hcd.c +2036 sitd_complete(64) 'stream'
> drivers/uwb/reset.c +193 __uwb_rc_cmd(26) 'cmd'
> (...)
> net/netfilter/xt_recent.c +273 recent_mt(69) 'e'
> (...)
> drivers/media/video/cpia_pp.c +777 cpia_pp_detach(28) 'cpia'
> (...)

These are less obvious.

Adding CCs.
Please leave only one of openfabrics/linux-usb/netdev/linux-media in CCs
when responding.

ps: [s]itd_complete is in drivers/usb/host/ehci-sched.c
