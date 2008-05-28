Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbYE1HEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbYE1HEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 03:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYE1HEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 03:04:15 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:37459 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbYE1HEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 03:04:14 -0400
Date: Wed, 28 May 2008 09:04:09 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: akpm@linux-foundation.org, linux@maxim.org.za,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Filter out FP during baud rate detection
Message-ID: <20080528090409.3f26878b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <cd73a99e0805271106n173dc05bk49748f112c602847@mail.gmail.com>
References: <1211894683-20934-1-git-send-email-haavard.skinnemoen@atmel.com>
	<cd73a99e0805271106n173dc05bk49748f112c602847@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 07:04:00.0025 (UTC) FILETIME=[01098090:01C8C091]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andrew Victor" <avictor.za@gmail.com> wrote:
> > I made a change to u-boot that used the FP (Fractional Part) field of
> > BRGR to achieve more accurate baud rate generation. Unfortunately, the
> > atmel_serial driver looks at the whole BRGR register when trying to
> > detect the baud rate that the port is currently running at, so setting
> > FP to a nonzero value breaks the baud rate detection.
> 
> > Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> 
> Acked-by: Andrew Victor <linux@maxim.org.za>

Thanks.

> The FP (Fractional Part) is not supported on some AT91 processors
> (RM9200, SAM9261) though.
> Those bits in BRGR are undefined.

Yes...I guess that's one more reason to filter them out.

FWIW, the u-boot patch explicitly excludes those two processors,
falling back to the existing CD calculation code.

Haavard
