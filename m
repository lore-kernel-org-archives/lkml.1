Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYLUQUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYLUQUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 11:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYLUQT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 11:19:59 -0500
Received: from server.drzeus.cx ([85.8.24.28]:38862 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752585AbYLUQT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 11:19:58 -0500
Date: Sun, 21 Dec 2008 17:19:55 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/11] drivers/mmc: Move a dereference below a NULL test
Message-ID: <20081221171955.15c82df8@mjolnir.drzeus.cx>
In-Reply-To: <Pine.LNX.4.64.0812161612440.20444@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812161612440.20444@pc-004.diku.dk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 16:13:09 +0100 (CET)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> In each case, if the NULL test is necessary, then the dereference should be
> moved below the NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 

Quite right. Queued up.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
