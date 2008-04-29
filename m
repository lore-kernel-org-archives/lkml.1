Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbYD2SXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbYD2SXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbYD2SXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:23:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52590 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbYD2SXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:23:09 -0400
Date: Tue, 29 Apr 2008 19:13:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [27/37] tehuti: move ioctl perm check closer to function start
 (CVE-2008-1675)
Message-ID: <20080429191310.203384eb@core>
In-Reply-To: <20080429171901.GB14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
	<20080429171901.GB14724@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 10:19:01 -0700
Greg KH <gregkh@suse.de> wrote:

> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.
> 
> ------------------
> From: Jeff Garzik <jeff@garzik.org>
> 
> Commit f946dffed6334f08da065a89ed65026ebf8b33b4 upstream
> 
> Noticed by davem.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/tehuti.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/drivers/net/tehuti.c
> +++ b/drivers/net/tehuti.c
> @@ -649,6 +649,9 @@ static int bdx_ioctl_priv(struct net_dev
>  		DBG("%d 0x%x 0x%x\n", data[0], data[1], data[2]);
>  	}
>  
> +	if (!capable(CAP_NET_ADMIN))
> +		return -EPERM;
> +

Should be CAP_SYS_RAWIO

Alan
