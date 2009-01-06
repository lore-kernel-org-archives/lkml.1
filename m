Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZAFVQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZAFVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZAFVQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:16:38 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:47998 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZAFVQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:16:36 -0500
Message-ID: <4963CA22.2080200@oracle.com>
Date: Tue, 06 Jan 2009 13:16:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexey Korolev <akorolev@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Vasiliy Leonenko <vasiliy.leonenko@gmail.com>
Subject: Re: linux-next: Tree for January 6 (MTD)
References: <20090106182311.525e4b14.sfr@canb.auug.org.au> <496386DB.8090606@oracle.com> <alpine.LFD.2.00.0901061632590.4300@casper.infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901061632590.4300@casper.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4963CA25.01C6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Korolev wrote:
> Hi Randy,
> 
>> # CONFIG_MTD_LPDDR is not set
>> CONFIG_MTD_QINFO_PROBE=y
>>
>> There appears to be too little control/coordination between those
>> two kconfig symbols.  Surely one of them (MTD_QINFO_PROBE) should
>> depend on the other (MTD_LPDDR).  And why even build 2 modules
>> when MTD_QINFO_PROBE is enabled?  Why not combine the code into
>> one module?
> Thanks a lot for good finding. Here is a fix for the problem.
> 
> About combining: it is assumed to have one QINFO probing module for several
> kinds of LPDDR command set drivers. If we combine two modules into
> one it would make further extension rather hard. So it is better to have
> two modules.
> To fix a problem I just added dependency in Kconfig file.
> This temporary fix which will work until we have just one cmdset module.
> In near future we will make a fix which parse command set types
>  and select proper driver according to device type.
> 
> Thanks,
> Alexey
> 
> Signed-off-by: Alexey Korolev <akorolev@infradead.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> diff --git a/drivers/mtd/lpddr/Kconfig b/drivers/mtd/lpddr/Kconfig
> index acd4ea9..5a401d8 100644
> --- a/drivers/mtd/lpddr/Kconfig
> +++ b/drivers/mtd/lpddr/Kconfig
> @@ -12,6 +12,7 @@ config MTD_LPDDR
>  	  DDR memories, intended for battery-operated systems.
>  
>  config MTD_QINFO_PROBE
> +	depends on MTD_LPDDR
>  	tristate "Detect flash chips by QINFO probe"
>  	help
>  	    Device Information for LPDDR chips is offered through the Overlay
> 
> 


-- 
~Randy
