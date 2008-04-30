Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbYD3Pbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbYD3Pbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757710AbYD3Pbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:31:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbYD3Pbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:31:34 -0400
Date: Wed, 30 Apr 2008 08:29:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Cc: "Mike Galbraith" <efault@gmx.de>, sfr@canb.auug.org.au,
       video4linux-list@redhat.com, "Sam Ravnborg" <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, mchehab@infradead.org,
       linux-dvb-maintainer@linuxtv.org, "Ingo Molnar" <mingo@elte.hu>,
       torvalds@linux-foundation.org, "David Miller" <davem@davemloft.net>
Subject: Re: [v4l-dvb-maintainer] [patch, -git] drivers/media build fix for
 modular builds
Message-Id: <20080430082959.5982ef70.akpm@linux-foundation.org>
In-Reply-To: <37219a840804300739t6bade9c0o2eeaeb0ef42dffee@mail.gmail.com>
References: <20080429185009.716c3284@gaivota>
	<20080430074807.GA11224@elte.hu>
	<20080430.005212.46815036.davem@davemloft.net>
	<20080430081345.GA16519@elte.hu>
	<1209544030.30990.2.camel@marge.simson.net>
	<1209544951.15609.3.camel@marge.simson.net>
	<1209545784.31419.2.camel@marge.simson.net>
	<1209547231.4898.2.camel@marge.simson.net>
	<20080430044009.6c5bbc8d.akpm@linux-foundation.org>
	<1209560592.5265.2.camel@marge.simson.net>
	<37219a840804300739t6bade9c0o2eeaeb0ef42dffee@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 10:39:31 -0400 "Michael Krufky" <mkrufky@linuxtv.org> wrote:

> >  [   13.691175] DVB: Unable to find symbol tda9887_attach()
> >  [   13.698968] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> >  [   13.709509] IP: [<ffffffff80302934>] strlcpy+0x11/0x36

hm.

> 
> Andrew's patch should have fixed the issue.  His patch was correct, btw...

They always are ;)  Watch this....

--- a/drivers/media/video/tuner-core.c~drivers-media-video-tuner-corec-tuner_probe-fix-error-check
+++ a/drivers/media/video/tuner-core.c
@@ -1181,7 +1181,7 @@ static int tuner_probe(struct i2c_client
 		case 0x60:
 			if (tuner_symbol_probe(tea5767_autodetection,
 					       t->i2c->adapter, t->i2c->addr)
-					!= EINVAL) {
+					!= -EINVAL) {
 				t->type = TUNER_TEA5767;
 				t->mode_mask = T_RADIO;
 				t->mode = T_STANDBY;
_

