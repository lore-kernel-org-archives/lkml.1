Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbYD3QCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbYD3QCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYD3QCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:02:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:35610 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755532AbYD3QCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:02:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+gljFUGISgYqDS0KyL4+vpsDKmzP/cG0RqSbLvPp
	5UnHqD9xYoNYS+
Subject: Re: [v4l-dvb-maintainer] [patch, -git] drivers/media build fix for
	modular builds
From: Mike Galbraith <efault@gmx.de>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au,
       video4linux-list@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, mchehab@infradead.org,
       linux-dvb-maintainer@linuxtv.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>
In-Reply-To: <37219a840804300839g55b53f31sdfd90bdede810455@mail.gmail.com>
References: <20080429185009.716c3284@gaivota>
	 <20080430081345.GA16519@elte.hu>
	 <1209544030.30990.2.camel@marge.simson.net>
	 <1209544951.15609.3.camel@marge.simson.net>
	 <1209545784.31419.2.camel@marge.simson.net>
	 <1209547231.4898.2.camel@marge.simson.net>
	 <20080430044009.6c5bbc8d.akpm@linux-foundation.org>
	 <1209560592.5265.2.camel@marge.simson.net>
	 <37219a840804300739t6bade9c0o2eeaeb0ef42dffee@mail.gmail.com>
	 <20080430083435.4302f82a.akpm@linux-foundation.org>
	 <37219a840804300839g55b53f31sdfd90bdede810455@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 18:01:55 +0200
Message-Id: <1209571315.4794.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 11:39 -0400, Michael Krufky wrote:

> 
> ...and about your previous fix:
> 
>  --- a/drivers/media/video/tuner-core.c~drivers-media-video-tuner-corec-tuner_probe-fix-error-check
> +++ a/drivers/media/video/tuner-core.c
> @@ -1181,7 +1181,7 @@ static int tuner_probe(struct i2c_client
>                 case 0x60:
>                         if (tuner_symbol_probe(tea5767_autodetection,
>                                                t->i2c->adapter, t->i2c->addr)
> -                                       != EINVAL) {
> +                                       != -EINVAL) {
>                                 t->type = TUNER_TEA5767;
>                                 t->mode_mask = T_RADIO;
>                                 t->mode = T_STANDBY;
> 
> 
> I think we're better off testing for >= 0.  Any < 0 should be
> considered a failure.

I tried it anyway, still went boom.

	-Mike

