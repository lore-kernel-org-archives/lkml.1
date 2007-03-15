Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422817AbXCOFgN (ORCPT <rfc822;akpm@zip.com.au>);
	Thu, 15 Mar 2007 01:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422811AbXCOFgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:36:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40962 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422817AbXCOFgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:36:12 -0400
Date: Thu, 15 Mar 2007 05:36:07 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] BLK_DEV_IDE_CELLEB dependency fix
Message-ID: <20070315053607.GQ4095@ftp.linux.org.uk>
References: <E1HRPb0-0003Eh-OG@ZenIV.linux.org.uk> <200703150523.l2F5NelE001987@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703150523.l2F5NelE001987@toshiba.co.jp>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 02:25:40PM +0900, Akira Iguchi wrote:
> Al wrote:
> >
> >It's bool and it depends on IDE => should depend on IDE=y
> >
> >Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Move to "if BLK_DEV_IDEDMA_PCI" block because it depends on 
> BLK_DEV_IDEDMA_PCI.

> +config BLK_DEV_IDE_CELLEB
> +	bool "Toshiba's Cell Reference Set IDE support"
> +	depends on PPC_CELLEB
> +	help
> +	  This driver provides support for the built-in IDE controller on
> +	  Toshiba Cell Reference Board.
> +	  If unsure, say Y.
> +

Eh...  You still need dependency on IDE=y; otherwise you'll get configs
with IDE=m, BLK_DEV_IDE_CELLEB=y and those won't link.  BLK_DEV_IDEDMA_PCI
is selectable just fine with IDE=m.

It's the same problem as with ps3 fb.
