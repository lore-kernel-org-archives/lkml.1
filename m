Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYCWA1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYCWA1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 20:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYCWA1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 20:27:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbYCWA1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 20:27:44 -0400
Date: Sat, 22 Mar 2008 17:27:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Libor Pechacek <lpechacek@suse.cz>
Cc: fubar@us.ibm.com, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] bonding: Fix sysfs attribute handling
Message-Id: <20080322172704.49fa557b.akpm@linux-foundation.org>
In-Reply-To: <200803211452.55982.lpechacek@suse.cz>
References: <200803211452.55982.lpechacek@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 14:52:55 +0100 Libor Pechacek <lpechacek@suse.cz> wrote:

> bonding: Fix sysfs attribute handling
> 
> For bonding interfaces any attempt to read the sysfs directory contents after
> module removal results in an oops.  The fix is to release sysfs attributes
> for the interfaces upon module unload.
> 
> Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
> --
>  drivers/net/bonding/bond_main.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 0942d82..33767d4 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4528,8 +4528,7 @@ static void bond_free_all(void)
>  		netif_tx_unlock_bh(bond_dev);
>  		/* Release the bonded slaves */
>  		bond_release_all(bond_dev);
> -		bond_deinit(bond_dev);
> -		unregister_netdevice(bond_dev);
> +		bond_destroy(bond);
>  	}

Is this also needed in 2.6.24.x?
