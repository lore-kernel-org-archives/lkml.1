Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbXKBNX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbXKBNX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbXKBNXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:23:49 -0400
Received: from web36703.mail.mud.yahoo.com ([209.191.85.37]:31295 "HELO
	web36703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753698AbXKBNXt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:23:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=X1jqKZa1tqTvuss04Fm/FjMmldtay61QdVcJ2Jqk8WFo3mcMvzwVOYxIAU6SM9For8YLVqBvHBs3PEv9Z48GDe6mZHyyoDDuykMHjLNCU0eFVwtJt+PVGVOexE+TBgAUuErnGs2pjvkwevswMY+VuTqQkDewvMHuhKj2HzoQ1ok=;
X-YMail-OSG: m_o0FAoVM1n8UquLKkohgjd9r4pc_8h6gFrGw2sKHIIwjOQoRJ3ZGw.lLhpuXDRB0rcT14sicAg5JYjfGRLbljXCJHeGaJ52xuzt9sdtCsIBuRTa8as-
X-Mailer: YahooMailRC/814.06 YahooMailWebService/0.7.134.12
Date: Fri, 2 Nov 2007 06:23:48 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: MemoryStick / Pro support
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Andrew Morton <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <331462.7246.qm@web36703.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After a much longer, than expected, time I managed to implement a support for MemoryStick (read-only currently, as there's still a subtle data corruption bug with writes) and MemoryStick Pro cards. The implementation follows the MMC driver model (there exist MSIO cards, but none are supported at the moment). The MS Pro support appears stable from what I can learn from user reports. Nevertheless, I've implemented a couple of diagnostics files in the "sys" filesystem, as well as low level format facility for legacy MS cards.

Currently only TI Flashmedia adapters are supported, but I'm working on a JMicron JMB38x adapter support and I know for sure that it'll be easy to support a Winbond 528 adapter, as I used its GPLed driver as a reference for  a more generic implementation.

I would like to get an advice on the way to arrange the files in the kernel tree. My current idea is:

memstick.h        -> include/linux
memstick.c        -> drivers/memstick      ("bus" support)
ms_block.c        -> drivers/memstick      (legacy MS storage support)
mspro_block.c   -> drivers/memstick      (MS Pro storage support)
tifm_ms.c          -> drivers/memstick      (TI Flashmedia low level driver)



I also wonder, where do I send the patches if nobody currently maintains this thing?




__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
