Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbXBROTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbXBROTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 09:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXBROTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 09:19:05 -0500
Received: from web36706.mail.mud.yahoo.com ([209.191.85.40]:22191 "HELO
	web36706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751213AbXBROTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 09:19:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=YFbPZx5n0MqnyxtfXjaD7mjq0MxcWvzktzm83E3wUhEsHu2CF4xU73je6Rv/8JrsDq5ujpbCXVQ1emzXiiC9zGBzVxEMj4whgCSEKuFIIiEL7p7Lk8GOxfXlsEbNntlZUkICbYCYJLM6VCbzNkKlPx1nB+0lH45eD+l0o7a21fo=;
X-YMail-OSG: BVsrcr8VM1l.5GbIULG_aBL548h.SmVZ1yBhQfxDzFCnM4MF__QKid4iXAa5EMN.fV6bhWxV2Y0q959gkPr.QkRtmH7mBsfpv3BKCCbQArDJLm5.bAenn_yTYCsyIRc.yKmZNJVf7oCE2Vs-
Date: Sun, 18 Feb 2007 06:19:03 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D80A94.308@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <306317.86250.qm@web36706.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I don't see how that is possible. mmc_block's remove routine waits for mmcqd to
> exit, so there can't be any code still alive that has a request going. (I am
> also completely unable to reproduce this problem here).
> 
> Add more printk:s do verify how the code in mmc_block executes.
> 
This is hard to trigger problem, so I'll spare you the rather lengthy log.
It happens if card timeouts and mmc_remove_host is called while mmc_register_card is still in
progress (the hint was in crash dump). If I sleep before remove, it gives the mmc_register_card
chance to finish/mark card as dead and everything's fine.
The remove callback of mmc_block is apparently not executed in this case (probably because device
has not finished registering).

My proposition: lets flush the workqueue first thing in the mmc_remove_host (and make sure that
nothing gets scheduled into it after this). 



 
____________________________________________________________________________________
Don't pick lemons.
See all the new 2007 cars at Yahoo! Autos.
http://autos.yahoo.com/new_cars.html 
