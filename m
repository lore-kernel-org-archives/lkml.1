Return-Path: <linux-kernel-owner+w=401wt.eu-S1750855AbXCTNh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbXCTNh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 09:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXCTNh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 09:37:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42994 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbXCTNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 09:37:25 -0400
Subject: Re: dquot.c: possible circular locking Re: [2.6.20] BUG: workqueue
	leaked lock
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20070320121909.GB14319@duck.suse.cz>
References: <20070315191749.GS31960@vanheusden.com>
	 <20070320111701.GB1751@ff.dom.local> <20070320112253.GC1751@ff.dom.local>
	 <20070320113151.GA12462@ff.dom.local> <20070320121909.GB14319@duck.suse.cz>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 20 Mar 2007 14:35:10 +0100
Message-Id: <1174397710.1158.75.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>   Yes, I was looking at it. Hmm, we can possibly get rid of tty_mutex being
> acquired under dqptr_sem in quota code. But looking at the path from
> con_close() there's another inversion with i_mutex which is also acquired
> along the path for sysfs. And we can hardly get rid of it in the quota code.
>   Now none of these is a real deadlock as quota should never call
> print_warning() for sysfs (it doesn't use quota) but still it's nasty. I
> suppose tty_mutex is above i_mutex because of those sysfs calls and it
> seems sysfs must be called under tty_mutex because of races with
> init_dev(). So it's not easy to get rid of that dependency either.

maybe a far more serious option: Why on EARTH is the quota code going to
TTY's directly? That's just WRONG. Maybe it wasn't 10 years ago, but
nowadays most people use graphical user interfaces and the like...

can we please just get rid of this instead?

