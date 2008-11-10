Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYKJWtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYKJWtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYKJWtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:49:22 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:41265 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751195AbYKJWtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:49:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ki3kdg4z//84lGJgdvf+cw8PyxW32NMIsdK2ak6vzCbjMBtNAaWFsj/zDmhRbrq3yVX3Yd3S5ET2+RCeikFVBGE1y+xB7uDWXxYUPIGoG73mgAIrEUpoInWZsv+f389LTGbCcjQcq6bjs+GMxWadA1wEg9fL+g+Ud8y0tBD4v3A=  ;
X-YMail-OSG: Y7ThyUAVM1nbEjw8MSjeMVnYQg9fB.R4s5UUyrZITrqpREyZgTbSQyLHNfmhjw4yG1cO0AD8lpTmeaQLZ846fafTDioVkt5MBfnx8odsH52VORw0o1XFpPlzE73R2Ym8SmO0Zy4PHjAJidypgZfVZFw6
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] rtc: bunch of drivers: fix 'no irq' case handing
Date: Mon, 10 Nov 2008 14:34:29 -0800
User-Agent: KMail/1.9.10
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
References: <20081106174111.GA21882@oksana.dev.rtsoft.ru>
In-Reply-To: <20081106174111.GA21882@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811101434.29772.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2008, Anton Vorontsov wrote:
> This patch fixes bunch of irq checking misuses.  Most drivers were getting
> irq via platform_get_irq(), which returns -ENXIO or r->start.  Platforms
> may specify r->start = 0 to emphasize 'no irq' case, and drivers should
> handle this correctly.

Just strike that "Platforms may specify..." sentence.  It's incorrect.
The normal way to specify "no IRQ" is, surprise!, to not specify one.

The rule about IRQ=0 is that it's not for generic driver use... and I
happen to know a family of platforms where it's used for the RTC and
a few other core system drivers.  (Your patch doesn't touch them.)


> ...
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


