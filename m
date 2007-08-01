Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbXHAWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbXHAWBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXHAWBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:01:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54465 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486AbXHAWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:01:07 -0400
Date: Wed, 1 Aug 2007 23:08:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: Ash Willis <ashwillis@programmer.net>, linux-kernel@vger.kernel.org,
       tiwai@suse.de
Subject: Re: CS5530 Alsa driver fails
Message-ID: <20070801230812.6f28bad0@the-village.bc.nu>
In-Reply-To: <46B0D628.3050409@interia.pl>
References: <20070801174103.D03341F50B1@ws1-2.us4.outblaze.com>
	<46B0D628.3050409@interia.pl>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I will give up. I didn't checked code earlier. This driver is using SMM. Probably  
> firmware isn't what it should be, or I have overwritten it when I was flashing 
> Linux. I see in datasheet that it isn't possible to write driver in other way. 
> Sadly sound card is generating SMI only.

The 5530 in native mode only generates SMI. I've always felt however that
if you make the buffers big enough you ought to be able to drive it off
the 1KHz timer tick by polling. Interesting project.

You btw won't have removed the SMM firmware or the box wouldn't boot. The
5530 uses SMM to emulate some of the most basic PC components including
the VGA video. If your box has VSA2 then VSA2 firmware has some kind of
hooks to allow a native sound driver to take over and to reroute the
interrupts without SB emulation. I don't have the docs for VSA2 but the
horribly big natsemi provided audio driver does show how to do it.

Alan
