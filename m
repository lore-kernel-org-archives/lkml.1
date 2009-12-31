Return-Path: <linux-kernel-owner+w=401wt.eu-S1751990AbZLaFWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbZLaFWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 00:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbZLaFWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 00:22:34 -0500
Received: from ozlabs.org ([203.10.76.45]:44728 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbZLaFWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 00:22:34 -0500
Date: Thu, 31 Dec 2009 15:49:26 +1100
From: Paul Mackerras <paulus@samba.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] arch/powerpc/boot/devtree.c: use %pM to show MAC
 address
Message-ID: <20091231044926.GC18358@brick.ozlabs.ibm.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F65E@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F65E@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 02:30:39PM -0500, H Hartley Sweeten wrote:

> Use the %pM kernel extension to display the MAC address.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> diff --git a/arch/powerpc/boot/devtree.c b/arch/powerpc/boot/devtree.c
> index a7e21a3..a2f07a5 100644
> --- a/arch/powerpc/boot/devtree.c
> +++ b/arch/powerpc/boot/devtree.c
> @@ -93,10 +93,7 @@ void dt_fixup_mac_address_by_alias(const char *alias, const u8 *addr)
>  	void *devp = find_node_by_alias(alias);
>  
>  	if (devp) {
> -		printf("%s: local-mac-address <-"
> -		       " %02x:%02x:%02x:%02x:%02x:%02x\n\r", alias,
> -		       addr[0], addr[1], addr[2],
> -		       addr[3], addr[4], addr[5]);
> +		printf("%s: local-mac-address <- %pM\n\r", alias, addr);

Nak - this isn't the kernel, this is a separate program, namely the
bootwrapper that decompresses the kernel image, and it has its own
printf (not printk) implementation in arch/powerpc/boot/stdio.c, which
doesn't understand the %pX extensions (and I don't see any good reason
to make it do so).

Paul.
