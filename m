Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZCEI10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZCEI10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZCEI1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:27:20 -0500
Received: from stinky.trash.net ([213.144.137.162]:60878 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZCEI1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:27:19 -0500
Message-ID: <49AF8CE0.6030301@trash.net>
Date: Thu, 05 Mar 2009 09:27:12 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Frank Blaschka <blaschka@linux.vnet.ibm.com>
CC: David Miller <davem@davemloft.net>, bart@jukie.net,
       greearb@candelatech.com, shemminger@vyatta.com, dada1@cosmosbay.com,
       frank.blaschka@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
References: <49AF79A6.6030002@trash.net>	<20090304.231120.86999183.davem@davemloft.net>	<49AF7B72.2020905@trash.net> <20090304.231911.213286076.davem@davemloft.net> <49AF7E93.2010800@trash.net> <49AF7FD3.5010709@trash.net> <49AF87D6.5040104@linux.vnet.ibm.com>
In-Reply-To: <49AF87D6.5040104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Blaschka wrote:
> Hi Dave, Patrick,
>
> sorry I could not follow the complete discussion of the fixes done for this problem
> but does
>
>  	if (netif_device_present(real_dev) && ops->ndo_neigh_setup)
> -		err = ops->ndo_neigh_setup(dev, pa);
> +		err = ops->ndo_neigh_setup(real_dev, pa);
>
> not change the idea of the neigh_setup? Remind we want the neigh_setup of the
> real device as the neigh setup function for the vlan device.
>   

An we still use it. The only difference is that we pass it the
correct device reference, which not only fixes the recursion,
but is also expected by the callbacks. Look at bonding or simply
vlan itself.

The setup itself is still done using the neigh_params passed to
VLAN, which appears to be what was originally intended.

