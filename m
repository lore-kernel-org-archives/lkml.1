Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZDCDU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZDCDU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 23:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZDCDUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 23:20:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:45039 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZDCDUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:20:16 -0400
Message-ID: <49D57FBA.3090508@windriver.com>
Date: Fri, 03 Apr 2009 11:17:14 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: norsk5@yahoo.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
Subject: Re: [v0 PATCH 5/5] EDAC: CPC925 MC platform device setup
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-5-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-6-git-send-email-qingtao.cao@windriver.com> <200904021436.44822.arnd@arndb.de>
In-Reply-To: <200904021436.44822.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Apr 2009 03:19:50.0519 (UTC) FILETIME=[0C904070:01C9B40B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann 写道:
> On Thursday 02 April 2009, Harry Ciao wrote:
>   
>> +#ifdef CONFIG_EDAC
>> +#define CPC925_MC_START                0xf8000000
>> +#define CPC925_MC_END          0xf8ffffff /* sizeof 16MB */
>> +/* Register a platform device for CPC925 memory controller */
>> +static int __init maple_cpc925_edac_setup(void)
>>     
>
> It's not good to have these encoded as magic numbers.
> Can't you find the addresses in the device tree? Maybe it's
> even possible to make this an of_platform_driver if you
> find a good node to bind to.
>
> Does the driver also work on a G5 Mac, or is it limited
> to the maple platform?
>
> 	Arnd <><
>
>  
Hi Arnd,

I did try to get resource information from its DTB node first, the 
"hostbridge" node do can be found successfully, however, unfortunately, 
as I put in the notes in that function, the #address-cells and 
#size-cells specified by its parent node are both 2, but the cell number 
used in its "reg" property is actually 1, as

reg = <0xf8000000 0x1000000>;

which will make of_address_to_resource() failed with -EINVAL; that's why 
I have to set it up from scratch manually.

Cheers,

Harry


