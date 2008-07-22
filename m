Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYGVEOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYGVEOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYGVEO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:14:27 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:13211 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYGVEO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:14:26 -0400
Date: Tue, 22 Jul 2008 06:19:14 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Julia Lawall <julia@diku.dk>
Cc: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 6/7] drivers/video: Release mutex in
 error handling code
Message-Id: <20080722061914.301275a8.krzysztof.h1@poczta.fm>
In-Reply-To: <Pine.LNX.4.64.0807210958320.24625@ask.diku.dk>
References: <Pine.LNX.4.64.0807210958320.24625@ask.diku.dk>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 38e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 09:58:55 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

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
> 
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

----------------------------------------------------------------------
Partyjka w Chinczyka?
Graj >>> http://link.interia.pl/f1e67

