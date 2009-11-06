Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZKFQpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZKFQpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbZKFQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:45:09 -0500
Received: from stinky.trash.net ([213.144.137.162]:33256 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425AbZKFQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:45:08 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2009 11:45:08 EST
Message-ID: <4AF450FC.3020205@trash.net>
Date: Fri, 06 Nov 2009 17:38:20 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Using netconsole and getting double prints
References: <43e72e890911051654i19c18bf3nd397662ed79712c4@mail.gmail.com>
In-Reply-To: <43e72e890911051654i19c18bf3nd397662ed79712c4@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> I'm getting double prints when using netconsole. This used to happen
> to me and then I just enable debugging log level manually (dmesg -n 8)
> but now no matter what I try I always get double prints.
> 
> For example:
> 
> [   23.425448] console [netcon0] enabled
> [   23.425567] netconsole: network logging started
> [   23.425448] console [netcon0] enabled
> [   23.425567] netconsole: network logging started
> [   32.856073] eth0: no IPv6 routers present
> [   32.856073] eth0: no IPv6 routers present
> [   66.307342] kmemleak: 6 new suspected memory leaks (see
> /sys/kernel/debug/kmemleak)
> [   66.307342] kmemleak: 6 new suspected memory leaks (see
> /sys/kernel/debug/kmemleak)
> 
> Instead of dmesg -8 I'm now using ignore_loglevel as a kernel
> parameter but I still get double prints. This also happens if I use
> "debug" as a kernel parameter instead.
> 
> The netconsole is set up on the dev box as follows through an /etc/rc.local
> 
> dhclient eth0
> IP=192.168.2
> # sudo dmesg -n 8
> modprobe netconsole netconsole=@/eth0,6666@${IP}/

Without a MAC address netconsole broadcasts the messages.
So I'd guess the receiving system has multiple NICs and
receives the message multiple times.
