Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYAGGoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYAGGoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 01:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYAGGnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 01:43:53 -0500
Received: from science.horizon.com ([192.35.100.1]:16606 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753833AbYAGGnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 01:43:53 -0500
Date: 7 Jan 2008 01:43:50 -0500
Message-ID: <20080107064350.5042.qmail@science.horizon.com>
From: linux@horizon.com
To: linux@horizon.com, romieu@fr.zoreil.com
Subject: Re: 2.6.24-rc6 oops in net_tx_action
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@linux-foundation.org
In-Reply-To: <20080106235719.GA10588@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> linux@horizon.com <linux@horizon.com> :
>> Kernel is 2.6.24-rc6 + linuxpps patches, which are all to the serial
>> port driver.
>> 
>> 2.6.23 was known stable.  I haven't tested earlier 2.6.24 releases.
>> I think it happened once before; I got a black-screen lockup with
>> keyboard LEDs blinking, but that was with X running so I couldn't see a
>> console oops.  But given that I installed 2.6.24-rc6 about 24 hours ago,
>> that's a disturbing pattern.

> It is probably this one:
>
> http://marc.info/?t=119782794000003&r=1&w=2

Thanks!  I got the patch from
http://marc.info/?l=linux-netdev&m=119756785219214
(Which didn't make it into -rc7; please fix!)
and am recompiling now.

Actually, I grabbed the hardware mitigation followon patch while I was
at it.  I notice that the comment explaining the format of CSR11 and
what 0x80F10000 means got lost; perhaps it would be nice to resurrect it?

0x80F10000
  80000000 = Cycle size (timer control)
  78000000 = TX timer in 16 * Cycle size
  07000000 = No. pkts before Int. (0 =  interrupt per packet)
  00F00000 = Rx timer in Cycle size
  000E0000 = No. pkts before Int.
  00010000 = Continues mode (CM)
  
(Boy, that tulip driver could use a whitespace overhaul.)
