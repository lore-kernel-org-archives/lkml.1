Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbZEGWBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbZEGWBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758770AbZEGWA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:00:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502AbZEGWAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:00:55 -0400
Date: Thu, 7 May 2009 14:57:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [v0 PATCH 1/1] Use dev_name() for AMD8111/AMD8131 EDAC driver
Message-Id: <20090507145722.b2d89e11.akpm@linux-foundation.org>
In-Reply-To: <1241660858-21105-2-git-send-email-qingtao.cao@windriver.com>
References: <1241660858-21105-1-git-send-email-qingtao.cao@windriver.com>
	<1241660858-21105-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 May 2009 09:47:38 +0800
Harry Ciao <qingtao.cao@windriver.com> wrote:

> The device structure no longer has bus_id member, dev_name() should
> be used for AMD8111 & AMD8131 EDAC driver instead. Also, their Makefile 
> entries are lost, add them.
> 
> Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
> ---
>  drivers/edac/Makefile       |    2 ++
>  drivers/edac/amd8111_edac.c |    4 ++--
>  drivers/edac/amd8131_edac.c |    2 +-
>  3 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index a5fdcf0..5907681 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -35,3 +35,5 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
>  obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
>  obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
>  obj-$(CONFIG_EDAC_PPC4XX)		+= ppc4xx_edac.o
> +obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
> +obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o

hm, I wonder how that happened.

The drivers break x86-64 allmodconfig:

drivers/edac/amd8111_edac.c: In function 'amd8111_lpc_bridge_init':
drivers/edac/amd8111_edac.c:260: error: implicit declaration of function '__do_inb'
drivers/edac/amd8111_edac.c:274: error: implicit declaration of function '__do_outb'

