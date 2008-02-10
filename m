Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYBJTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYBJTib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYBJTiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:38:21 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:54787 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYBJTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:38:21 -0500
Date: Sun, 10 Feb 2008 20:38:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Faster way to run through building single modules
In-Reply-To: <20080210192821.GB13733@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802102035000.7915@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802101950020.7915@fbirervta.pbzchgretzou.qr>
 <20080210192821.GB13733@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10 2008 20:28, Sam Ravnborg wrote:
>On Sun, Feb 10, 2008 at 07:51:29PM +0100, Jan Engelhardt wrote:
>> 
>> I was wondering whether there is a shortcut in kbuild I can take if I 
>> just want to rebuild one module. Currently, I have:
>> 
>> make net/bridge/netfilter/ebtables.ko
>
>Fool kbuild to think this is an external module using:
>make M=`pwd` net/bridge/netfilter/ebtables.ko
>
>That should do the trick.

How would I combine that with O=? Not quite doing the right thing yet.

linux$ touch net/bridge/netfilter/ebtables.c 
linux$ make O=/home/jengelh/Coding/linux-obj M=$PWD
       net/bridge/netfilter/ebtables.ko

make[2]: Nothing to be done for `net/bridge/netfilter/ebtables.o'.
  MODPOST 0 modules
  CC      arch/x86/kernel/asm-offsets.s
  GEN     /home/jengelh/Coding/linux_nosov/include/asm-x86/asm-offsets.h
  Building modules, stage 2.
  MODPOST 0 modules


And:

$ touch net/bridge/netfilter/ebtables.c 
$ make O=... M=$PWD net/bridge/netfilter/ebtables.o
  CC [M]  /home/jengelh/Coding/linux_nosov/net/bridge/netfilter/ebtables.o
$ make O=... M=$PWD net/bridge/netfilter/ebtables.ko
make[2]: Nothing to be done for `net/bridge/netfilter/ebtables.o'.
  MODPOST 0 modules
