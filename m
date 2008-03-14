Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYCNN3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYCNN3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYCNN3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:29:33 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:49753 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbYCNN3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:29:06 -0400
Date: Fri, 14 Mar 2008 22:29:32 +0900 (JST)
Message-Id: <20080314.222932.74752532.anemo@mba.ocn.ne.jp>
To: haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, avictor.za@gmail.com,
       tiwai@suse.de
Subject: Re: [PATCH] at73c213: Fix DMA size at the end of DMA buffer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080314104445.32f4da40@hskinnemo-gx620.norway.atmel.com>
References: <20080310.234306.15242180.anemo@mba.ocn.ne.jp>
	<20080314104445.32f4da40@hskinnemo-gx620.norway.atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 10:44:45 +0100, Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > +		size = runtime->period_size * runtime->channels;
> > +		if (next_period == runtime->periods - 1)
> > +			size += (runtime->buffer_size % runtime->period_size)
> > +				* runtime->channels;
> 
> Ow. That looks expensive. Isn't there any way we can force the client
> to select sane values of buffer_size and period_size?

Well, I suppose it is not _too_ expensive. :)

> It seems like a reasonable demand that buffer_size is a multiple of
> period_size, doesn't it?

But actually it can happen.  And I gave up understanding how are these
parameters determined...  If there were any way the driver can enforce
that constraint, it would be better fix.

Iwai-san, any comments from alsa guru?

---
Atsushi Nemoto
