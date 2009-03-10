Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZCJR1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZCJR1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbZCJR1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:27:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754330AbZCJR1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:27:43 -0400
Date: Tue, 10 Mar 2009 10:26:48 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH 01/31] bridge: Auto-load bridge module when socket
 opened.
Message-ID: <20090310102648.125aa7e5@nehalam>
In-Reply-To: <74b87ec3359e6e65d59cd6fb62a83fb469e6c8ae.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
	<74b87ec3359e6e65d59cd6fb62a83fb469e6c8ae.1236702228.git.scott@canonical.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.15.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 16:40:10 +0000
Scott James Remnant <scott@canonical.com> wrote:

> The bridge module is missing the net-pf-7 alias that would cause it to
> be auto-loaded when a socket of that type is opened.  This patch adds
> the alias.
> 
> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  net/bridge/br.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index 4d2c1f1..229daee 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -16,6 +16,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  #include <linux/init.h>
> +#include <linux/net.h>
>  #include <linux/llc.h>
>  #include <net/llc.h>
>  #include <net/stp.h>
> @@ -108,3 +109,4 @@ module_init(br_init)
>  module_exit(br_deinit)
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(BR_VERSION);
> +MODULE_ALIAS_NETPROTO(PF_BRIDGE);

Hmm. It looks okay, but there is not real direct socket interface
for PF_BRIDGE/AF_BRIDGE.
