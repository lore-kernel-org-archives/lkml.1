Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYG3VYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYG3VYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYG3VYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:24:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57050 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbYG3VYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:24:00 -0400
Message-ID: <4890DBE6.4080408@pobox.com>
Date: Wed, 30 Jul 2008 17:23:50 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: raisch@de.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/net/ehea/ehea_main.c: Release mutex in error
 handling code
References: <Pine.LNX.4.64.0807210957060.24625@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0807210957060.24625@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The mutex is released on a successful return, so it would seem that it
> should be released on an error return as well.
> 
> The semantic patch finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression l;
> @@
> 
> mutex_lock(l);
> ... when != mutex_unlock(l)
>     when any
>     when strict
> (
> if (...) { ... when != mutex_unlock(l)
> +   mutex_unlock(l);
>     return ...;
> }
> |
> mutex_unlock(l);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

applied


