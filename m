Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab0CMMdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:33:22 -0500
Received: from ist.d-labs.de ([213.239.218.44]:43746 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab0CMMdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:33:18 -0500
Date: Sat, 13 Mar 2010 13:33:15 +0100
From: Florian Mickler <florian@mickler.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 2/2] enhance sysfs rfkill interface
Message-ID: <20100313133315.16e42e7e@schatten.dmk.lab>
In-Reply-To: <20100313095554.GA16038@core.coreip.homeip.net>
References: <1268416988-24862-1-git-send-email-florian@mickler.org>
	<1268416988-24862-2-git-send-email-florian@mickler.org>
	<1268416988-24862-3-git-send-email-florian@mickler.org>
	<20100312182209.GB8736@core.coreip.homeip.net>
	<20100312215743.7671d173@schatten.dmk.lab>
	<20100312212025.GA17712@core.coreip.homeip.net>
	<20100312233925.74effc7d@schatten.dmk.lab>
	<20100312224828.GA18618@core.coreip.homeip.net>
	<20100313104128.79aa2846@schatten.dmk.lab>
	<20100313095554.GA16038@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010 01:55:54 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:


> Well, right now it is mutex so it will not protect if something happens
> in interrupt context. Takeing the global rfkill mutex seems pretty heavy
> but there does not seem to be a per-device mutex. There also some
> muching with spinlock inside rfkill_set_state but it is dropped when we
> actually carry out the operation. I am afraid the locking in rfkill
> needs some reviewing...
> 

I _think_ this is ok... 
as far as i can see everything which writes to rfkill->state in
net/rfkill/core.c takes the rfkill->lock spinlock... the mutex
probably protects other global rfkill data... as long as drivers only
use the rfkill.h interface and not acess the rfkill->state
themselves this should be ok... 

Flo

