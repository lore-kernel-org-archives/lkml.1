Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbXJLWLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbXJLWLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbXJLWK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:10:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58292 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbXJLWK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:10:57 -0400
Date: Sat, 13 Oct 2007 00:10:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
In-Reply-To: <470FEBEF.4000204@oracle.com>
Message-ID: <Pine.LNX.4.64.0710130008330.24587@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
 <470FEBEF.4000204@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12 2007 14:49, Randy Dunlap wrote:
> Jan Engelhardt wrote:
>> Allow config variables in .config to override earlier ones in the same
>> file. In other words,
>> 
>>  # CONFIG_SECURITY is not defined
>>  CONFIG_SECURITY=y
>> 
>> will activate it. This makes it a bit easier to do
>> 
>>  (cat original-config myconfig myconfig2 ... >.config)
>> 
>> and run menuconfig as expected.
>
> This is a feature that we want IMO, but I already do this without having
> a patch for it (although to a lesser degree than full config files;
> I just cat a few entries to the end of a config file then run oldconfig)...
> so are there some cases where it works and some cases
> where it doesn't work?  Do you know what those cases are?

$ echo "CONFIG_CRC7=m" >>../obj-2.6.23/.config

$ make O=/ws/linux/obj-2.6.23 menuconfig
  GEN     /ws/linux/obj-2.6.23/Makefile
scripts/kconfig/mconf arch/i386/Kconfig
.config:3669:warning: trying to reassign symbol CRC7
	(Just save+exit)

$ grep CONFIG_CRC7 ../obj-2.6.23/.config
# CONFIG_CRC7 is not set
