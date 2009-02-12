Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZBLLs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZBLLs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbZBLLsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:48:46 -0500
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:20611 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756509AbZBLLsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:48:45 -0500
Date: Thu, 12 Feb 2009 20:48:40 +0900 (JST)
Message-Id: <20090212.204840.124087545.nemoto@toshiba-tops.co.jp>
To: thierry.reding@avionic-design.de
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com
Subject: Re: [PATCH] dmaengine: Fix oops on dmatest module unload.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1234258263-1805-1-git-send-email-thierry.reding@avionic-design.de>
References: <1234258263-1805-1-git-send-email-thierry.reding@avionic-design.de>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 10:31:03 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> This patch fixes an oops that happens when the dmatest module is unloaded. The
> dma_release_channel() function is called on channels that have already been
> cleaned up (and therefore freed) with dmatest_cleanup_channel().
...
> @@ -433,10 +433,10 @@ static void __exit dmatest_exit(void)
>  
>  	list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node) {
>  		list_del(&dtc->node);
> +		dma_release_channel(dtc->chan);
>  		dmatest_cleanup_channel(dtc);
>  		pr_debug("dmatest: dropped channel %s\n",
>  			 dma_chan_name(dtc->chan));
> -		dma_release_channel(dtc->chan);
>  	}
>  }

Good catch!  Please move pr_debug() too.

---
Atsushi Nemoto
