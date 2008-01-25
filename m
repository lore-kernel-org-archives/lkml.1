Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYAYPXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYAYPXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbYAYPWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:22:53 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46396 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYAYPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:22:52 -0500
Date: Fri, 25 Jan 2008 16:22:51 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce softpanic
In-Reply-To: <p73ejc67xvb.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0801251621300.15243@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz> <p73ejc67xvb.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 25 2008 16:01, Andi Kleen wrote:
>Bodo Eggert <7eggert@gmx.de> writes:
>
>> Enabling this option changes a hard panic on boot errors to a
>> soft panic, which does not stop the system completely.
>> You can still scroll the screen and read the messages.
>
>I don't think it's a good idea to keep the network running in the
>soft panic. A lot of people have set ups that use ping was a watchdog
>and with nfsroot/ip=dhcp ping does work quite well before
>mounting root and then the watchdog might not pick up the 
>soft panic.

If the machine goes oops and softlocks (e.g. bug in root filesystem,
lock held but not released, box essentially dead), ping also still
works even though you'd probably want to trigger the watchdog too.

>Using a polled keyboard driver after panic seems to be the better
>option to me, but if you want softpanic you should probably
>at least add a suitable panic notifier to the network stack 
>to shut it all down.

or that.
