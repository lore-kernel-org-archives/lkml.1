Return-Path: <linux-kernel-owner+w=401wt.eu-S934420AbXGUPqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbXGUPqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbXGUPqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:46:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39277 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbXGUPqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:46:46 -0400
Date: Sat, 21 Jul 2007 17:46:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: pata_platform: Fix NULL pointer dereference
In-Reply-To: <alpine.LFD.0.999.0707200910020.27249@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707211746050.21737@fbirervta.pbzchgretzou.qr>
References: <20070720035058.25300.28389.sendpatchset@clockwork.opensource.s
 e> <alpine.LFD.0.999.0707200910020.27249@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20 2007 09:12, Linus Torvalds wrote:
>Ok, the *fix* looks real enough, but it seems that you have done your line 
>splitting with a word processor rather than with a source code editor:
>
>> +	return ata_host_activate(host, platform_get_irq(pdev, 0),
>> +				 ata_interrupt, pp_info ? pp_info->irq_flags
>> +				 : 0, &pata_platform_sht);
>
>Please don't do things like this. Splitting up expressions across two 
>lines just to make the line length come out "right" is silly.
>
>So do the
>
>	"pp_info ? pp_info->irq_flags : 0"
>
>expression on one line.

Or just do

	return ata_host_activate(host, platform_get_irq(pdev, 0),
	       ata_interrupt, pp_info ? pp_info->irq_flags : 0,
	       &pata_platform_sht);

for returns, it's ok.


	Jan
-- 
