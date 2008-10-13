Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYJMDkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYJMDkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 23:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYJMDj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 23:39:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:52918 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYJMDj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 23:39:56 -0400
Message-ID: <48F2C2D0.3000805@larces.uece.br>
Date: Mon, 13 Oct 2008 00:38:56 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] drivers/mfd/ucb1400_core.c: fix undefined reference to
 `ac97_bus_type'
References: <48F22345.1040407@larces.uece.br> <20081012150328.b272975c.randy.dunlap@oracle.com>
In-Reply-To: <20081012150328.b272975c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 12 Oct 2008 13:18:13 -0300 Sergio Luis wrote:
> 
>> randconfig got a problem with ucb1400_core.c (config attached)
>>
>> drivers/built-in.o:(.data+0x15ab4): undefined reference to `ac97_bus_type'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> ucb1400 is an ac97 audio codec. express this dependency in Kconfig
>>
>> Signed-off-by: Sergio Luis <sergio@larces.uece.br>
>> Cc: Marek Vasut <marek.vasut@gmail.com>
>>
>> drivers/mfd/Kconfig |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index 0dae245..fa851c5 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -52,6 +52,7 @@ config HTC_PASIC3
>>  
>>  config UCB1400_CORE
>>  	tristate "Philips UCB1400 Core driver"
>> +	select AC97_BUS
>>  	help
>>  	  This enables support for the Philips UCB1400 core functions.
>>  	  The UCB1400 is an AC97 audio codec.
> 
> Hi,
> 
> Andrew has a "depends on AC97_BUS" patch queued and approved... fwiw.
> 
> The problem with "select AC97_BUS" is that SOUND could be =n and
> selecting AC97_BUS still will not enable SOUND, so it's useless
> (unless/until kconfig is taught to follow select dependencies).
> 
> ---
> ~Randy

Ah, yeah, you are correct. Thanks for the explanation.

Sergio.
