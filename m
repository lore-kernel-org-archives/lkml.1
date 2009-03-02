Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbZCBDmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbZCBDmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 22:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbZCBDlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 22:41:52 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:37609 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbZCBDlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 22:41:51 -0500
Message-ID: <49AB55B9.3050301@oracle.com>
Date: Sun, 01 Mar 2009 19:42:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Cheng Renquan <crquan@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: Re: [PATCH 0/6] [KBUILD] configuration system improvements
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>
In-Reply-To: <1235401804-8136-1-git-send-email-crquan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49AB5565.011B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cheng Renquan wrote:
> This group of patches improve the usability of kernel configuration system,
> mainly,
> 
> 1. add symbol's value shown accompanied in config item's help message;
> 2. move the real plumbing functions code from mconf.c to menu.c, make them
>    be able to be shared with other configuration methods;
> 3. add "symbol's value shown" support for gconfig/xconfig/config;
> 
>   0001--KBUILD-add-symbol-value-to-help-find-the-real-depe.patch
>   0002--KBUILD-add-menu_get_ext_help-function-to-display-m.patch
>   0003--KBUILD-menuconfig-improvements.patch
>   0004--KBUILD-make-use-of-menu_get_ext_help-in-gconfig.patch
>   0005--KBUILD-make-use-of-menu_get_ext_help-in-qconfig.patch
>   0006--KBUILD-make-use-of-menu_get_ext_help-in-make-conf.patch
> 
> I found gconfig still lack of "search by symbol" support, and that would be
> in another patch.
> 
> Request for comments, thanks.

Hi,

I still like this idea a lot.  However, with "make gconfig" I am
seeing a segfault when I click on "Firmware Drivers" in the main menu.
I only see this with these patches applied.

Other than that, they look good to me.


Here's the gconfig info:
rddunlap@chimera:linux-2.6.29-rc6-git5> make ARCH=x86_64 O=xx64 gconfig &
[1] 10722
rddunlap@chimera:linux-2.6.29-rc6-git5>   GEN     /local/linsrc/tmp/linux-2.6.29-rc6-git5/xx64/Makefile
scripts/kconfig/gconf arch/x86/Kconfig
make[2]: *** [gconfig] Segmentation fault
make[1]: *** [gconfig] Error 2
make: *** [sub-make] Error 


and from the kernel log:

gconf[10868]: segfault at 0000000000000070 rip 00000000004111b6 rsp 00007ffff67cd6f0 error 4


Thanks,
-- 
~Randy
