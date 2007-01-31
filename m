Return-Path: <linux-kernel-owner+w=401wt.eu-S1030443AbXAaUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030443AbXAaUiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030377AbXAaUiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:38:13 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:46964 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030446AbXAaUiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:38:13 -0500
Message-ID: <45C0FE30.4000800@ru.mvista.com>
Date: Wed, 31 Jan 2007 23:38:08 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	<20070119003226.14846.87052.sendpatchset@localhost.localdomain>	<45B4FFBD.40507@ru.mvista.com> <20070122184620.1c8b87ac@localhost.localdomain>
In-Reply-To: <20070122184620.1c8b87ac@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan wrote:

>>    Ugh, I'm not seeing any *actual* support for MW/SW DMA in this driver... 

> Thats long been broken. Should be correct in the libata driver

    I've looked thru the specs and it seemed to me that ULi hardware is much 
broken PIO wise: their max active time is 8 cycles even on taskfile access 
which gives 240 ns while standard requeires 290 ns for modes 0 thru 2...

    I've also noted that the tuneproc() method in both cmd64x.c and alim15x3.c 
seems to misdo recovery calculation, taking address setup into account -- that 
should be slightly overclocking PIO modes 0/1 (ULi docs don't shed much light 
on how it should be calculated)... Well, this seems fixed in libata drivers.

> Alan

MBR, Sergei
