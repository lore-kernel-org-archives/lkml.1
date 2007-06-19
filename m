Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbXFSQbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbXFSQbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXFSQay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:30:54 -0400
Received: from h155.mvista.com ([63.81.120.155]:38490 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754790AbXFSQax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:30:53 -0400
Message-ID: <46780524.4010301@ru.mvista.com>
Date: Tue, 19 Jun 2007 20:32:36 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Lord <lkml@rtr.ca>, Linas Vepstas <linas@austin.ibm.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com>	<20070618212704.394912b8@the-village.bc.nu>	<20070618204601.GF5836@austin.ibm.com>	<20070618220441.3a3af8ca@the-village.bc.nu>	<4677E3BC.3040307@ru.mvista.com>	<20070619151919.79c79af1@the-village.bc.nu>	<4677E726.1080602@ru.mvista.com>	<4677F881.6060200@rtr.ca> <20070619171745.7c2240bf@the-village.bc.nu>
In-Reply-To: <20070619171745.7c2240bf@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>   Indeed... but the thing is we don't know what's asserted in this case 
>>>-- remember, it's reading the status register that locks everything up...

>>Exactly.  And IORDY shouldn't really apply there,
>>unless some nitwit standards person wrote it into a spec..

> Could it be we need to reset the state machine at this point before we
> touch the registers again - that wouldn't be the first controller with
> this limit and undocumented.

> On the 370 we already 

    Yeah, that could be. And because IORDY pin becomes DSTROBE for UltraDMA it 
might have stuck low due to this (if the chip never asserted STOP)...

> Alan

MBR, Sergei
