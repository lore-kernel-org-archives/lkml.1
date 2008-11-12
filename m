Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYKLASK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYKLASK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYKLARy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:17:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbYKLARx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:17:53 -0500
Date: Tue, 11 Nov 2008 16:17:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: a.zummo@towertech.it, david-b@pacbell.net, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: bunch of drivers: fix 'no irq' case handing
Message-Id: <20081111161728.8a0d73f1.akpm@linux-foundation.org>
In-Reply-To: <20081106174111.GA21882@oksana.dev.rtsoft.ru>
References: <20081106174111.GA21882@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 20:41:11 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch fixes bunch of irq checking misuses.  Most drivers were getting
> irq via platform_get_irq(), which returns -ENXIO or r->start.  Platforms
> may specify r->start = 0 to emphasize 'no irq' case, and drivers should
> handle this correctly.
> 
> rtc-cmos.c is special.  It is using PNP and platform bindings.  Hopefully
> nobody is using PNP IRQ 0 for RTC.  So the changes should be safe.
> 
> rtc-sh.c is using platform_get_irq, but was storing a result into an
> unsigned type, then was checking for < 0.  This is fixed now.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Do we see any reason why this should be pushed into 2.6.28?
