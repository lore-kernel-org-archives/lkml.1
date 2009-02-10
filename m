Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZBJADy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZBJADy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZBJADp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:03:45 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:41485 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZBJADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:03:45 -0500
Date: Tue, 10 Feb 2009 00:03:43 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Roel Kluin <roel.kluin@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: Z85C30: BCM1480: loops should end at 0
In-Reply-To: <498EFCF8.5070106@gmail.com>
Message-ID: <alpine.LFD.1.10.0902092358310.12457@ftp.linux-mips.org>
References: <498EFCF8.5070106@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Roel Kluin wrote:

> With a postfix decrement 'loops' reach -1, not 0, which is subsequently
> returned. In drivers/serial/zs.c, line 1137 it is considered as a boolean with 0
> as failure:
> 
> if (zs_transmit_drain(zport, irq))
>                 write_zsdata(zport, ch);
> 
> so to use it as such loops should end at 0 after the loop rather than -1.
> This also fix similar issues in other functions.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Another solution would be to change the test at drivers/serial/zs.c, line 1137:
> 
> if (zs_transmit_drain(zport, irq) == -1)
> 
> Is that preferred?

 I'm tempted to rewrite these as do {} while loops instead.  Thanks for 
the report -- I'm running out of disk space on my development system 
again, so please allow me a couple of days to make a clean-up before I get 
back to your report.  The change has to be split into two separate 
patches, BTW.

  Maciej
