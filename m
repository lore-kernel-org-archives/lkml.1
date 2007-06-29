Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbXF2RWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbXF2RWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759361AbXF2RWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:22:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:48428 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248AbXF2RWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:22:44 -0400
Date: Fri, 29 Jun 2007 21:23:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Sattler <tsattler@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Holger Waechtler <holger@qanu.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       v4l-dvb-maintainer@linuxtv.org
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070629172332.GA480@tv-sign.ru>
References: <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de> <20070629130955.GA284@tv-sign.ru> <20070629131605.GA25964@elte.hu> <20070629135848.GA332@tv-sign.ru> <20070629141059.GA8995@elte.hu> <d120d5000706290959w2feed4eehec7f5a115fc5de04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706290959w2feed4eehec7f5a115fc5de04@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Dmitry Torokhov wrote:
>
> Well, not really maintainer but I think the short term soluton (at
> least for the RC part) is to alter cinergyt2_query_rc to take
> cinergyt2->sem only around cinergyt2_command(). Ther rest of the
> polling function need not be protected as it does nto tun concurently
> with itself.

Can't comment, because I know nothing about this stuff.

But, unless I misread this patch, it doesn't solve the problem.
cinergyt2_release() calls flush_scheduled_work() under ->sem,
but ->query_work takes it too, no?

Quoting myself,
>
>  I think cinergyt2_query() and cinergyt2_query_rc() should not use
>  ->disconnect_pending at all. cinergyt2_disconnect() should set
>  ->disconnect_pending = 1 and cancel both delayed_works.
>
>  cinergyt2_release() checks !->disconnect_pending and does the cancel
>  without mutex.

Possible?

Oleg.

