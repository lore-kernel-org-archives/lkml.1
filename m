Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbXJMWiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbXJMWiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbXJMWiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:38:01 -0400
Received: from userg501.nifty.com ([202.248.238.81]:32778 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbXJMWiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:38:00 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=elcfT1lj3QGE0DICqYMDVgEVQejQkyLhPVQNikpU2gbidbcioFcLaQhKx8ml+eHkr
	X4+6oOWmD2Afst8SJp0MA==
X-Nifty-SrcIP: [219.104.15.224]
Date: Sun, 14 Oct 2007 07:36:58 +0900
From: Komuro <komurojun@nifty.com>
To: davem@sunset.davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [NOT VERY SAFE]     [TCP]: Set initial_ssthresh default to zero in
 Cubic and BIC.
Message-Id: <20071014073658.d4352b8c.komurojun@nifty.com>
In-Reply-To: <20071006132601.f944f461.komurojun@nifty.com>
References: <20071006132601.f944f461.komurojun@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dear David

The patch "[TCP]: Set initial_ssthresh default to zero in Cubic and BIC."
is not very safe.

With this patch, ftp-transfer stops in my system.
(vsftpd-2.0.5-8)

Please revert this patch.


Best Regards
Komuro

>commit 66e1e3b20cbbf99da63e6c1af0fc6d39c2ed099a
>Author: David S. Miller <davem@sunset.davemloft.net>
>Date:   Wed Jun 13 01:03:53 2007 -0700
>
>    [TCP]: Set initial_ssthresh default to zero in Cubic and BIC.
>    
>    Because of the current default of 100, Cubic and BIC perform very
>    poorly compared to standard Reno.
>    
>    In the worst case, this change makes Cubic and BIC as aggressive as
>    Reno.  So this change should be very safe.
>    
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
>diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
>index 281c9f9..dd9ef65 100644
>--- a/net/ipv4/tcp_bic.c
>+++ b/net/ipv4/tcp_bic.c
>@@ -29,7 +29,7 @@ static int fast_convergence = 1;
> static int max_increment = 16;
> static int low_window = 14;
> static int beta = 819;		/* = 819/1024 (BICTCP_BETA_SCALE) */
>-static int initial_ssthresh = 100;
>+static int initial_ssthresh;
> static int smooth_part = 20;
> 
> module_param(fast_convergence, int, 0644);
>diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
>index 1422448..ebfaac2 100644
>--- a/net/ipv4/tcp_cubic.c
>+++ b/net/ipv4/tcp_cubic.c
>@@ -29,7 +29,7 @@
> static int fast_convergence __read_mostly = 1;
> static int max_increment __read_mostly = 16;
> static int beta __read_mostly = 819;	/* = 819/1024 (BICTCP_BETA_SCALE) */
>-static int initial_ssthresh __read_mostly = 100;
>+static int initial_ssthresh __read_mostly;
> static int bic_scale __read_mostly = 41;
> static int tcp_friendliness __read_mostly = 1;
> 
