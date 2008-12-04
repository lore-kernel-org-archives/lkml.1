Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYLDQKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYLDQKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYLDQKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:10:21 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:23427 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750924AbYLDQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:10:20 -0500
Message-ID: <493800E8.7070901@ru.mvista.com>
Date: Thu, 04 Dec 2008 19:10:16 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
References: <E1L4UpB-0007ro-1g@localhost> <492A8306.9000400@ru.mvista.com>	 <492A9A1F.50401@ru.mvista.com>	 <20081124123231.555f2395@lxorguk.ukuu.org.uk>	 <492AAE6C.7000103@ru.mvista.com> <b2b2f2320812031908se18efdft1a94cb2b158f540e@mail.gmail.com>
In-Reply-To: <b2b2f2320812031908se18efdft1a94cb2b158f540e@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Shane McDonald wrote:

>>Alan Cox wrote:

>>>>> It's 240, not 242 ns as 33 is actually 33.333.

>>>> The maximum values give cycle time of 480 ns menaing that the controller
>>>>doesn't support PIO mode 0. Hm...

>>>Even if you clear the enable for the timing register ?

>>  These fast timing bits are documented as reserved.

> The spec says that PIO mode 0 is supported, but Sergei is correct --
> the maximum values give a cycle time of 480 ns.  How can this be?  The
> old driver appeared to have tried to support PIO mode 0 by setting to
> the maximum.

>   Which fast timing bits are documented as reserved?  My spec has the
> IDE Drive 0/1 Recovery Time and IDE Drive 0/1 Pulse Width bits in it.
> Are there other timing bits that aren't documented in my spec?

    Off the top of my head: bits 0, 3, 4, and 7 at offset 0x40 are not 
reserved in PIIX/ICH -- they enable the programmable timings for PIO and/or 
DMA. If they were left cleared, 600 ns cycle (PIO mode 0) was used.

>   Please excuse my dumb question -- I'm a little over my head here.

>>>Alan

> Shane

MBR, Sergei
