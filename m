Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbXDFT1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbXDFT1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbXDFT1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:27:45 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:59647 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S932192AbXDFT1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:27:44 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 15:27:43 EDT
Message-ID: <46169DDA.6020008@ru.mvista.com>
Date: Fri, 06 Apr 2007 23:22:02 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Suleiman Souhlal <ssouhlal@freebsd.org>
CC: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Correctly prevent IDE timer expiry function to run if
 request was already handled
References: <20070406173603.GA82722@freefall.freebsd.org>
In-Reply-To: <20070406173603.GA82722@freefall.freebsd.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Suleiman Souhlal wrote:

> It is possible for the timer expiry function to run even though the
> request has already been handled: ide_timer_expiry() only checks that
> the handler is not NULL, but it is possible that we have handled a
> request (thus clearing the handler) and then started a new request
> (thus starting the timer again, and setting a handler). 

> A simple way to exhibit this is to set the DMA timeout to 1 jiffy and
> run dd: The kernel will panic after a few minutes because
> ide_timer_expiry() tries to add a timer when it's already active.

> To fix this, we simply add a request generation count that gets
> incremented at every interrupt, and check in ide_timer_expiry() that
> we have not already handled a new interrupt before running the expiry
> function.

    Couldn't this be addressed by simply changing add_timer() to mod_timer()?

MBR, Sergei
