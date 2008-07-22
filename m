Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYGVWTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYGVWTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYGVWTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:19:32 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:49247 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYGVWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:19:31 -0400
Message-ID: <48865CE0.3020605@euromail.se>
Date: Wed, 23 Jul 2008 00:19:12 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net,
       Oliver Neukum <oliver@neukum.org>, stern@rowland.harvard.edu
Subject: Re: [PATCH] linux-input: bcm5974-0.57: mode-switch to atp_open,	cleanup
 bug fixed
References: <1216466049.6238.0.camel@alnilam> <20080720051016.GA7853@anvil.corenet.prv> <1216688142.4768.26.camel@alnilam> <20080722093606.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080722093606.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.11
X-ACL-Warn: Too high rate of unknown addresses received from you
X-Scan-Result: No virus found in message 1KLQCf-0001ZB-7e.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KLQCf-0001ZB-7e 0483749e822147b4181f0d359042db02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

thank you so much for your answers! I would like to send you
a non-patch of the updated driver shortly if I may; it will
require more testing before submission, but having your blessing
first should make things turn around faster.

> >
> > 3. From the state (!opened,suspended), calling open gets us to what
> > state?
> >

Depens on the kind of suspend - manual suspend will cause open to
fail. Autosuspend (if driver implements it) should resume the device.

[...]

>> 5. From the state (opened,suspended), calling resume fails. What state
>> are we in?
>>
> 
> Screwed up ;) From the driver POV still (opened, suspended) I think.
> 

I feel a bit reluctant to implement this particular behavior, since it
will leave the device in a bad state; if resume fails and stays suspended,
the device cannot later be opened according to 3). What if a failed
resume leaves the device in state (!opened,!suspended)? It could then
later be reopened.

Cheers,
Henrik Rydberg

