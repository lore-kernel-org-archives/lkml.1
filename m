Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbYHAUOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbYHAUOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYHAUOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:14:07 -0400
Received: from smtp102.vzn.mail.mud.yahoo.com ([68.142.203.46]:39098 "HELO
	smtp102.vzn.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752560AbYHAUOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:14:07 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 16:14:06 EDT
X-YMail-OSG: E8MAOWcVM1nO4_.mRmLybZsgJKpUYjavljDQKfHmZ2BSvDeu7YgXLFEImQ5TROt4EmAtmSa18dQh9dLB29dtW63kAM3LfA.D2wROYPHTp8mlzxK8TncEP7rKRzN9SsgjTrc-
X-Yahoo-Newman-Property: ymail-3
From: "Gerard Kam" <gerardk5@verizon.net>
To: "'Haavard Skinnemoen'" <haavard.skinnemoen@atmel.com>
Cc: "'David Brownell'" <david-b@pacbell.net>,
       <spi-devel-general@lists.sourceforge.net>,
       "'Lars Steubesand'" <lars.steubesand@philips.com>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] atmel_spi: fix hang due to missed interrupt
Date: Fri, 1 Aug 2008 13:07:24 -0700
Message-ID: <008301c8f412$37dc6b00$2f01a8c0@hobbes>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6838
In-reply-to: <20080801154931.120632f1@hskinnemo-gx745.norway.atmel.com>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
Thread-Index: Acjz3XqVhEXXYYoWSjKDOdWlFpSs6QALZV6g
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there

> -----Original Message-----
> From: Haavard Skinnemoen [mailto:haavard.skinnemoen@atmel.com]
> Sent: Friday, August 01, 2008 6:50 AM
> 
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> >  		spi_writel(as, RNCR, 0);
> >  		spi_writel(as, TNCR, 0);
 
> These writes are also completely pointless -- RNCR is zeroed 
> automatically after it gets shifted into RCR.

While looking at the patch yesterday I was thinking the same thing.  Now it
bugs me that this observation didn't occur when I was working on this
problem.  Maybe the code symmetry makes it look "correct".

> Actually, I think the real bug happens right here

You're probably correct.  A race condition that intermittently clears a
pending interrupt fits the observed symptom.

 
> As for the overruns, I'm beginning to suspect that the only way to get
> rid of those and still maintain a reasonable transfer rate is to use
> bounce buffers in faster RAM (e.g. on-chip SRAM).

For my at91sam9260 board, I eliminated one cause of SPI overruns by lowering
the interrupt priorities of the six USARTs (default was 5, changed to 4)
relative to the two SPI controllers (default is 5).  The test I used for
this issue is 'ls -lR' on the flash filesystem.

Regards -- Gerard

