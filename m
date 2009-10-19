Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZJSGSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZJSGSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 02:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZJSGSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 02:18:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54036
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbZJSGSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 02:18:24 -0400
Date: Sun, 18 Oct 2009 23:18:46 -0700 (PDT)
Message-Id: <20091018.231846.205270907.davem@davemloft.net>
To: tomoki.sekiyama.qu@hitachi.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, satoshi.oshima.fk@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, hideo.aoki.tk@hitachi.com
Subject: Re: [PATCH] AF_UNIX: Fix deadlock on connecting to shutdown socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ADC010C.5070809@hitachi.com>
References: <4ADC010C.5070809@hitachi.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Date: Mon, 19 Oct 2009 15:02:52 +0900

> I found a deadlock bug in UNIX domain socket, which makes able to DoS
> attack against the local machine by non-root users.
 ...
> Why this happens:
>  Error checks between unix_socket_connect() and unix_wait_for_peer() are
>  inconsistent. The former calls the latter to wait until the backlog is
>  processed. Despite the latter returns without doing anything when the
>  socket is shutdown, the former doesn't check the shutdown state and
>  just retries calling the latter forever.
> 
> Patch:
>  The patch below adds shutdown check into unix_socket_connect(), so
>  connect(2) to the shutdown socket will return -ECONREFUSED.
> 
> Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
> Signed-off-by: Masanori Yoshida <masanori.yoshida.tv@hitachi.com>

Looks good, applied, thank you!
