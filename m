Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXLJHJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXLJHJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 02:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXLJHJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 02:09:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51450 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXLJHJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 02:09:41 -0500
Subject: Re: [PATCH] vivi driver works only as first device
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, Ted Walther <ted@enumera.com>,
       John Sokol <sokol@videotechnology.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071206220634.GT17496@vidsoft.de>
References: <20071203225610.GS17496@vidsoft.de>
	 <20071206220634.GT17496@vidsoft.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 10 Dec 2007 05:08:51 -0200
Message-Id: <1197270531.5168.5.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregor,
Em Qui, 2007-12-06 às 23:06 +0100, Gregor Jasny escreveu:
> From: Gregor Jasny <gjasny@web.de>
> 
> When the vivi driver allocates a video device, video_register_device() stores the
> allocated device minor inside the vivi structure. But when the device node is opened,
> the file minor number is compared to the minor in the device list. So this patch
> copies the allocated minor in the device list, too.

Thanks for the report. Instead of applying your patch, I decided to
better analyze the issue, fixing it with the proper solution. The issue
is that vivi_register changes iminor, but this change were not properly
returned to the driver.

-- 
Cheers,
Mauro

