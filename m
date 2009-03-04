Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZCDGFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZCDGFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbZCDGFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:05:37 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58224 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZCDGFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:05:36 -0500
Date: Wed, 4 Mar 2009 07:05:33 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?J=2EA=2E_Magall=C3=B3n?= <jamagallon@ono.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mdv Cooker <cooker@mandrivalinux.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Bonding tied to IPV6 in 29-rc5
In-Reply-To: <20090217095232.5da06b9f@werewolf.home>
Message-ID: <alpine.LSU.2.00.0903040702001.9232@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain> <20090217095232.5da06b9f@werewolf.home>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2009-02-17 09:52, J.A. Magallón wrote:

>Hi all...
>
>Don't know if this is specific for -rc5, I have jumped from 28.4 to 29-rc5.
>In this latest kernel, I can not install 'bonding' module if 'ipv6' is
>disabled to load via modprobe.conf:
>
>install ipv6 /bin/true
>
>Trying bonding gives this dmesg:
>
>bonding: Unknown symbol ndisc_build_skb
>bonding: Unknown symbol in6_dev_finish_destroy
>bonding: Unknown symbol ndisc_send_skb
>bonding: Unknown symbol unregister_inet6addr_notifier
>bonding: Unknown symbol register_inet6addr_notifier
>
>Commenting the line in modprobe.conf makes things smooth again.
>We can not disable ipv6 anymore ?

Well, given ipv6 is now a runtime dependency when compiled
with CONFIG_IPV6={m,y}, it seems about right what you see.
I would not call this a regression.

$ modinfo bonding
filename:       /lib/modules/2.6.29-rc6-jen77-rt/kernel/bonding.ko.gz
author:         Thomas Davis, tadavis@lbl.gov and many others
description:    Ethernet Channel Bonding Driver, v3.5.0
version:        3.5.0
license:        GPL
srcversion:     752CFD14F79DC79CF4BFB2E
depends:        ipv6
                ^^^^
