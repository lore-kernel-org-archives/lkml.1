Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYIEWtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYIEWtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 18:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYIEWtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 18:49:07 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:3604 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYIEWtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 18:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CqUpp99nyh+yGyTSEsnZ8jKgKvHmqPMzn+HXRWbsBDaTAbLuZqrJMxnRo71Z9ixorb
         6f3zmgL8V8v1JG84TGpnEHMQfMwDHgMiPmeycBboHOPovkPac1uDZj6Q+g0TfnnPjzvF
         p5a90LLAfokL1N6DmyB2W/3hMXFB1BFQfwK7k=
Date: Sat, 6 Sep 2008 02:50:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: sort-of regression due to "kconfig: speed up all*config +
	randconfig"
Message-ID: <20080905225047.GG11569@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, allmodconfig automatic testing is on fire!

I use KCONFIG_ALLCONFIG= heavily to pin some config options to N and
now CONFIG_MODULES aren't set to y after allmodconfig.

Step to reproduce:

	rm .config
	rm 1
	touch 1
	make KCONFIG_ALLCONFIG=1 allmodconfig >/dev/null
	grep CONFIG_MODULES .config

CONFIG_MODULES is =n after this patch, which is strange given definition
of allmodconfig.

If KCONFIG_ALLCONFIG= is removed, MODULES are back to =y.


f443d2eccf077afd8a839cc7ed66cc4d520c5f05 is first bad commit
commit f443d2eccf077afd8a839cc7ed66cc4d520c5f05
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Mon Jun 30 22:45:38 2008 +0200

    kconfig: speed up all*config + randconfig
    
    Drop the chatty mode when we generate the all*config, randconfig
    configurations.
    Ths speeds up the process considerably and noone looked
    at the output anyway.
    This patch uses the conf_set_all_new_symbols() function
    just added to kconfig.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Cc: Roman Zippel <zippel@linux-m68k.org>

:040000 040000 abd92c139f2ed97f93b1c9475023f713103f11f3 509069e7fb8fc2e2139f65b14b136febd20ac102 M	scripts

