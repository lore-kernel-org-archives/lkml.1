Return-Path: <linux-kernel-owner+w=401wt.eu-S934163AbZHEKbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbZHEKbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933959AbZHEKbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:31:34 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:16996 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933956AbZHEKbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:31:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJL7eEpR9dzM/2dsb2JhbADUawmEDwU
Date: Wed, 5 Aug 2009 12:31:27 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add watchdog driver for w90p910
Message-ID: <20090805103127.GF30892@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com> <20090804201032.GB30892@infomag.iguana.be> <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com> <20090805070822.GC30892@infomag.iguana.be> <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

> > I have an additional question: which timeout values can you set? is it 0, 1, 2 and 3 seconds?
> 
> The 0, 1, 2 and 3 is not seconds, rather than 'level' , it means my
> watchdog controller can only set four grades,
> When WTIS bit of REG_WTCR was set one value of  the 0, 1, 2 and 3, the
>  real time interval can be calculated via following formula .
> 
> WTIS                 real time interval (formula)
> 0x00                   ((2^ 14 ) * ((external crystal freq) / 256))seconds
> 0x01                   ((2^ 16 ) * ((external crystal freq) / 256))seconds
> 0x02                   ((2^ 18 ) * ((external crystal freq) / 256))seconds
> 0x03                   ((2^ 20 ) * ((external crystal freq) / 256))seconds
> 
> The external crystal freq is 15Mhz in w90p910 evaluation board. so I
> set the '0x00' as a default value, it means the real time interval is
> 0.28 second approximately.

Hmm, the watchdog API works in seconds.
A timer will need to be used like in similar watchdog drivers (like at91sam9_wdt.c, pcwd.c).

Kind regards,
Wim.

