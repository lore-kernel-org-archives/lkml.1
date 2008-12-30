Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbYL3Ttm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbYL3Ttm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 14:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYL3Tte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 14:49:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53504 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbYL3Ttd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 14:49:33 -0500
Date: Tue, 30 Dec 2008 17:49:06 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andy Walls <awalls@radix.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [v4l-dvb-maintainer] [patch] fix warning in
 drivers/media/dvb/dvb-usb/af9005-fe.c
Message-ID: <20081230174906.647ff5b8@pedra.chehab.org>
In-Reply-To: <1230409474.3121.27.camel@palomino.walls.org>
References: <20081224121252.7560391e@caramujo.chehab.org>
	<20081225081907.GA4628@elte.hu>
	<20081225212459.4c7e31b4@caramujo.chehab.org>
	<20081226090220.GF755@elte.hu>
	<20081226111324.3fbb804b@caramujo.chehab.org>
	<20081226132426.GA26953@elte.hu>
	<20081227120020.GA8660@elte.hu>
	<1230409474.3121.27.camel@palomino.walls.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Dec 2008 15:24:34 -0500
Andy Walls <awalls@radix.net> wrote:

> On Sat, 2008-12-27 at 13:00 +0100, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > Btw., there's a handful of warning fixes i carry in tip/warnings/* topic 
> > branches - you can find them in tip/master via:
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> > 
> > the ones affecting drivers/media/ are:
> > 
> >   f3e67e2: fix warning in drivers/media/video/usbvision/usbvision-i2c.c
> >   491af31: fix warning in drivers/media/video/cx18/cx18-mailbox.c
> 
> Mauro & Ingo,
> 
> If the cx18 warning message is fixed in the following diff, that I
> culled from a LKML posting by Ingo on 29 Nov, then Ingo's patch for
> cx18-mailbox.c should be overcome by events in the latest v4l-dvb repo.
> "req" is now always assigned a value before it is ever used.  (Sorry, I
> didn't want to pull the > 100 MB git/tip down over my dialup connection
> to verify this was the item in question).
> 
> 
> diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
> index acff7df..5c847be 100644
> --- a/drivers/media/video/cx18/cx18-mailbox.c
> +++ b/drivers/media/video/cx18/cx18-mailbox.c
> @@ -184,7 +184,7 @@ long cx18_mb_ack(struct cx18 *cx, const struct cx18_mailbox *mb)
>  static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
>  {
>  	const struct cx18_api_info *info = find_api_info(cmd);
> -	u32 state = 0, irq = 0, req, oldreq, err;
> +	u32 state = 0, irq = 0, uninitialized_var(req), oldreq, err;
>  	struct cx18_mailbox __iomem *mb;
>  	wait_queue_head_t *waitq;
>  	int timeout = 100;

This patch also didn't apply.

I also couldn't reproduce this warning here [1].

[1] gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-44)

Ingo,

I've added almost 600 patches on my merge tree, several of them that I've
merged recently from driver maintainers. I've already fixed all warnings I got
here with allmodconfig.

Could you please double check if the patches you've added on your tree are still needed?

Thanks,
Mauro.

