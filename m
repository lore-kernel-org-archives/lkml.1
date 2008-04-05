Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYDEXVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYDEXVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 19:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYDEXVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 19:21:21 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:57037
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbYDEXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 19:21:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIBAImm90d8qMuH/2dsb2JhbAAIqh+CHw
X-IronPort-AV: E=Sophos;i="4.25,610,1199631600"; 
   d="scan'208";a="312008310"
Subject: [BUG, bisected] atmel_spi: hard lockups in transfer
From: Ben Nizette <bn@niasdigital.com>
To: kernel <kernel@avr32linux.org>, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       slipszi@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Nias Digital
Date: Sun, 06 Apr 2008 09:28:38 +1000
Message-Id: <1207438118.3319.8.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For some weeks now there have been reports flying across the main AVR32
support forum, avrfreaks [1], that atmel_spi now hard-hangs on most
transfers.  The behaviour is not apparent in .23 and is in .24+.  One
tester was good enough to bisect the problem and turned up

154443c72f47169ebcb3a7befbff0e934c49bff3
atmel_spi: chain DMA transfers

as the culprit.  The tester also had to revert 

commit 8bacb219018a52e6f02a3cff6a7badf102ddfc44
atmel_spi: fix dmachain oops with DEBUG enabled

when they reverted 154443 as they were not confident enough to resolve
the conflicts that resulted from just reverting the first one.

The discussion thread involving this can be seen at [2].

As I say, this is present in .24+ so any fix will be a stable candidate
as well as .25 material (if we haven't missed the boat by then).

Thanks,
	--Ben.

[1] http://www.avrfreaks.net
[2]
http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&t=61891&start=20&sid=ef480fc809343ec9eff35b0cda643ffc
