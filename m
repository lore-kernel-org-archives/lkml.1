Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYAISai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYAISai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYAISab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:30:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42360 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYAISaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:30:30 -0500
Date: Wed, 9 Jan 2008 16:30:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PATCHES] V4L/DVB fixes
Message-ID: <20080109163002.58cb933b@gaivota>
In-Reply-To: <200801091643.52658.hpj@urpla.net>
References: <20080107073818.368243b9@gaivota>
	<200801091643.52658.hpj@urpla.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 16:43:51 +0100
Hans-Peter Jansen <hpj@urpla.net> wrote:

> +	/* The mspx4xx chips need a longer delay for some reason */
> +	if (!(itv->hw_flags & IVTV_HW_MSP34XX))
> +		itv->i2c_algo.udelay = 5;
> +
> 
> where the logic in hunk #1 was switched, resulting in a now misleading 
> comment over there.

If you notice the ! at the above line, and remind that the original value for 
udelay is 10, you can understand the comment ;)
> 
> How about something in the line of:
> 
> 	/* 
> 	 * We started with a bigger udelay in order to fulfill the needs of the
> 	 * mspx4xx chips: cut it down here for all other members of the family.
> 	 */

Your suggestion seems clearer to my eyes. Still the other possibilities are not
from Micronas msp34xx family, but audio decoder chips from other vendors - as
weel as other kind of i2c devices, like IR chips, video encoders, etc.

So, IMO, a better comment would be something like:

 	/* 
 	 * We started with a bigger udelay in order to avoid troubles with some
 	 * msp34xx chips. Boards without msp34xx are known to work with the full
	 * i2c 100 kHz speed.
	 */

I'm C/C the patch author (Hans) for his comments about this, since he is
the one who faced with the problems with msp34xx and ivtv.


Cheers,
Mauro
