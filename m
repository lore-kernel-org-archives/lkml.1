Return-Path: <linux-kernel-owner+w=401wt.eu-S1763838AbXJNVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763838AbXJNVQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXJNVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:16:29 -0400
Received: from host06.hostingexpert.com ([216.80.70.60]:52438 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbXJNVQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:16:28 -0400
Message-ID: <47128718.2070603@linuxtv.org>
Date: Sun, 14 Oct 2007 17:16:08 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: tuner-core.c:fe_has_signal() can returne uninitialized value
References: <20071014175159.GO4211@stusta.de>
In-Reply-To: <20071014175159.GO4211@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Commit 1f5ef19779df2c2f75870332b37dd3004c08a515 added the following 
> function to drivers/media/video/tuner-core.c:
>
> <--  snip  -->
>
> static int fe_has_signal(struct tuner *t)
> {
>         struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
>         u16 strength;
>
>         if (fe_tuner_ops->get_rf_strength)
>                 fe_tuner_ops->get_rf_strength(&t->fe, &strength);
>
>         return strength;
> }
>
> <--  snip  -->
>
>
> If (!fe_tuner_ops->get_rf_strength) this function returns the value of 
> an uninitialized variable.
>
> Spotted by the Coverity checker.
>   
Thank you, Adrian.  I've fixed this in my tree:

http://linuxtv.org/hg/~mkrufky/v4l-dvb/rev/101ca558a777

Mauro, please pull from:

http://linuxtv.org/hg/~mkrufky/v4l-dvb

for:

- tuner-core.c: fe_has_signal() can return uninitialized value

 tuner-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Please send this to Linus for 2.6.24

Regards,

Mike
