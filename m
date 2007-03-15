Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbXCOUJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbXCOUJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933784AbXCOUJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:09:43 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:54449 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933679AbXCOUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:09:42 -0400
In-Reply-To: <20070315191258.GA752@stusta.de>
References: <C6F49569-655E-4B17-B9DA-9644C8B3668D@kernel.crashing.org> <20070315191258.GA752@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <88F9283D-B8FD-46F9-8A94-CB824630C232@kernel.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: fake config option w/kbuild?
Date: Thu, 15 Mar 2007 15:08:47 -0500
To: Adrian Bunk <bunk@stusta.de>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 15, 2007, at 2:12 PM, Adrian Bunk wrote:

> On Thu, Mar 15, 2007 at 10:19:03AM -0500, Kumar Gala wrote:
>> ...
>> My initial question is that I don't want anyone using CONFIG_QE_83xx
>> or CONFIG_QE_85xx in code, the second part is if there is a way to
>> remove duplicating the QE_83xx/QE_85xx options down in platform/8 
>> {3,5}
>> xx/Kconfig.
>
>
> What about the following solution:
>
>
> arch/powerpc/Kconfig.qe:
>
> <--  snip  -->
>
> config MACH_SUPPORTS_QE
> 	bool
>
> config QE
> 	bool "QUICC Engine Support"
> 	depends on MACH_SUPPORTS_QE
> 	help
> 	  ...
>
> <--  snip  -->
>
>
> arch/powerpc/platforms/83xx/Kconfig:
>
> <--  snip  -->
>
> ...
> source arch/powerpc/Kconfig.qe
>
> config PPC_MPC836x
>         bool
> 	select MACH_SUPPORTS_QE
> 	...
> ....
>
> <--  snip  -->

Not sure this helps since I end up having to source arch/powerpc/ 
Kconfig.qe from both arch/powerpc/platforms/83xx/Kconfig & arch/ 
powerpc/platforms/85xx/Kconfig and then mconf grips about having  
already scanned Kconfig.qe.

- k

