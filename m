Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXL2Bh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXL2Bh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXL2BhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:37:20 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:23019 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752718AbXL2BhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:37:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UCU32+xOsCOxDjlyydC+UZa6DHSoR8F2shNGUpj72zZ8hUkLmT98ysuMgWml/eVrGSccA5YknAGpZeylXab89Kdi53fQMFaV00509EFyrYSq1erFbcDLQacTThlZIENFp+T1aGG+Z9Igj1FvW+U0zAGvvAKaXhim+1fcreqUjmE=  ;
X-YMail-OSG: 46afUfYVM1k3vr2gTZ_a.O.NEPPde0RBTmlp7LNyZIV4RF6hCs4wwYrduEn_7qhSz33sEhaAaQ--
From: David Brownell <david-b@pacbell.net>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 11/12] spi : Use mutex instead of semaphore in driver core
Date: Fri, 28 Dec 2007 17:37:12 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
References: <20071229011858.GL2883@darkstar.te-china.tietoenator.com>
In-Reply-To: <20071229011858.GL2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712281737.13145.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007, Dave Young wrote:
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

ACK ... if the driver core is changing, this is obvious.
 
> ---
> drivers/spi/spi.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -upr linux/drivers/spi/spi.c linux.new/drivers/spi/spi.c
> --- linux/drivers/spi/spi.c	2007-12-28 10:47:38.000000000 +0800
> +++ linux.new/drivers/spi/spi.c	2007-12-28 10:48:22.000000000 +0800
> @@ -494,7 +494,7 @@ struct spi_master *spi_busnum_to_master(
>  	struct spi_master	*master = NULL;
>  	struct spi_master	*m;
>  
> -	down(&spi_master_class.sem);
> +	mutex_lock(&spi_master_class.mutex);
>  	list_for_each_entry(dev, &spi_master_class.children, node) {
>  		m = container_of(dev, struct spi_master, dev);
>  		if (m->bus_num == bus_num) {
> @@ -502,7 +502,7 @@ struct spi_master *spi_busnum_to_master(
>  			break;
>  		}
>  	}
> -	up(&spi_master_class.sem);
> +	mutex_unlock(&spi_master_class.mutex);
>  	return master;
>  }
>  EXPORT_SYMBOL_GPL(spi_busnum_to_master);
> 


