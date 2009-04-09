Return-Path: <linux-kernel-owner+w=401wt.eu-S934069AbZDIO3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069AbZDIO3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbZDIO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:28:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:38859 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbZDIO2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:28:38 -0400
Cc: Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
       Greg KH <greg@kroah.com>, sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Message-Id: <BE92FB74-1784-414B-B27F-8329185EB3AE@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: subrata@linux.vnet.ibm.com
In-Reply-To: <1239285152.5188.66.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [BUILD FAILURE 04] Next April 9 : PPC64 randconfig [drivers/net/ibm_newemac/core.c]
Date: Thu, 9 Apr 2009 09:28:23 -0500
References: <1239285152.5188.66.camel@subratamodak.linux.ibm.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9, 2009, at 8:52 AM, Subrata Modak wrote:

> Observed the following build error:
>
> CC      drivers/net/ibm_newemac/core.o
> drivers/net/ibm_newemac/core.c: In function ‘emac_probe’:
> drivers/net/ibm_newemac/core.c:2831: error: ‘struct net_device’ has no
> member named ‘open’
> drivers/net/ibm_newemac/core.c:2834: error: ‘struct net_device’ has no
> member named ‘tx_timeout’
> drivers/net/ibm_newemac/core.c:2836: error: ‘struct net_device’ has no
> member named ‘stop’
> drivers/net/ibm_newemac/core.c:2837: error: ‘struct net_device’ has no
> member named ‘get_stats’
> drivers/net/ibm_newemac/core.c:2838: error: ‘struct net_device’ has no
> member named ‘set_multicast_list’
> drivers/net/ibm_newemac/core.c:2839: error: ‘struct net_device’ has no
> member named ‘do_ioctl’
> drivers/net/ibm_newemac/core.c:2841: error: ‘struct net_device’ has no
> member named ‘hard_start_xmit’
> drivers/net/ibm_newemac/core.c:2842: error: ‘struct net_device’ has no
> member named ‘change_mtu’
> drivers/net/ibm_newemac/core.c:2845: error: ‘struct net_device’ has no
> member named ‘hard_start_xmit’
> make[3]: *** [drivers/net/ibm_newemac/core.o] Error 1
> make[2]: *** [drivers/net/ibm_newemac] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
>
> Regards--
> Subrata
>
> <randconfig4-ppc64-next20090409.txt>

This is because CONFIG_COMPAT_NET_DEV_OPS isnt set and needs to be for  
this driver to build.  I've asked the netdev guys about either fixing  
the driver or adding the proper thing to Kconfig to select  
CONFIG_COMPAT_NET_DEV_OPS.

- k