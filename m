Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbXFURGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbXFURGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXFURGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:06:25 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:61152 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755758AbXFURGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:06:24 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Thu, 21 Jun 2007 19:06:17 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
cc: jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 11/12] pcmcia/net_pcmcia: all net_pcmcia modules
 depend on PCMCIA
Message-ID: <20070621170617.GH5193@alberich.amd.com>
References: <20070619225203.GM5193@alberich.amd.com>
 <20070620134435.21410ceb.randy.dunlap@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20070620134435.21410ceb.randy.dunlap@oracle.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Jun 2007 17:05:12.0603 (UTC)
 FILETIME=[54B196B0:01C7B426]
X-WSS-ID: 6A64707423K1043238-06-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 01:44:35PM -0700, Randy Dunlap wrote:
> On Wed, 20 Jun 2007 00:52:03 +0200 Andreas Herrmann wrote:
> 
> > Fix several build errors with PCMCIA=m && NET_PCMCIA=y:
> > 
> >    LD      .tmp_vmlinux1
> >    drivers/built-in.o: In function `nmclan_release':
> >    nmclan_cs.c:(.text+0x14026c): undefined reference to `pcmcia_disable_device'
> >    ...
> >    drivers/built-in.o: In function `exit_xirc2ps_cs':
> >    xirc2ps_cs.c:(.exit.text+0x1055): undefined reference to `pcmcia_unregister_driver'
> >    make: *** [.tmp_vmlinux1] Error 1
> 
> This is interesting.  This is a result of the menuconfig changes,
> which made NET_PCMCIA a boolean, and then some tristates depend
> on NET_PCMCIA and the boolean -> tristate dependencies aren't
> specific enough.
> 
> Your fix is one way to do it.  I'd prefer to make
> NET_PCMCIA a tristate instead, then let its value trickle down
> to the subordinate config symbols.
> 
> This probably means that some of the other menuconfig changes
> need to be audited for this "feature."
> 
> 
> Here is my preferred patch.
> ~~~~~~~~~~
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make NET_PCMCIA a tristate symbol so that net/pcmcia drivers
> are constrained to M when needed.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/net/pcmcia/Kconfig |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- linux-2.6.22-rc5.orig/drivers/net/pcmcia/Kconfig
> +++ linux-2.6.22-rc5/drivers/net/pcmcia/Kconfig
> @@ -3,14 +3,14 @@
>  #
>  
>  menuconfig NET_PCMCIA
> -	bool "PCMCIA network device support"
> +	tristate "PCMCIA network device support"
>  	depends on PCMCIA


Yes this solves the problem.
... and is the preferred variant.


Regards,

Andreas


-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



