Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYCXMc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYCXMc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 08:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYCXMcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 08:32:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50318 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbYCXMcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 08:32:21 -0400
Date: Mon, 24 Mar 2008 13:32:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: linux-kernel@vger.kernel.org
Subject: Re: your old menuconfig patch series, and select
In-Reply-To: <20080324065436.GA24085@khazad-dum.debian.net>
Message-ID: <alpine.LNX.1.10.0803241329490.27005@fbirervta.pbzchgretzou.qr>
References: <20080324040514.GC3321@khazad-dum.debian.net> <alpine.LNX.1.10.0803240542030.27005@fbirervta.pbzchgretzou.qr> <20080324065436.GA24085@khazad-dum.debian.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-03-24 07:54, Henrique de Moraes Holschuh wrote:
> On Mon, 24 Mar 2008, Jan Engelhardt wrote:
>> It "does not work" either if LEDS_CLASS is put outside of the if block
>> and instead gets a "depends on LEDS_CLASS".
>
> So, select is not walking the dep chain.  Bad form, that, but I am sure
> it is for a good reason.  Well, select NEW_LEDS plus select LED_CLASS it
> is, then.  I'd have appreciated the Kconfig toolchain warning me of it,
> but maybe I just don't know how to ask it to :-)

'select' is doing its job — it enables LEDS_CLASS. It leaves NEW_LEDS
off though, since LEDS_CLASS "only" has a 'depends' on NEW_LEDS,
and not a 'select'. This is kind of a discrepancy for Kconfig rather
than a bug; it gets two inputs:
- CONFIG_FOO tells me to enable LEDS_CLASS
- LEDS_CLASS tells me to disable LEDS_CLASS because NEW_LEDS is off
In the end, it leaves LEDS_CLASS=m in the .config file and NEW_LEDS=off.
