Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbXGBOsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbXGBOsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXGBOrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:47:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38484 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXGBOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:47:54 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] se401: fix "&& 0x" typo
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: pe1rxq@amsat.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, devel@openvz.org
In-Reply-To: <20070702110453.GA6634@localhost.sw.ru>
References: <20070702110453.GA6634@localhost.sw.ru>
Content-Type: text/plain; charset=utf-8
Date: Mon, 02 Jul 2007 11:46:42 -0300
Message-Id: <1183387602.5456.106.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Seg, 2007-07-02 às 15:04 +0400, Alexey Dobriyan escreveu:
> Code there survived trivial regexp made earlier, but after bulk preprocessing
> was done...
> 
> ===>	if (!cp[2] && 0x40) {	<===
> 		printk("<3>" "%s: " "Bayer format not supported!" ...
> 		return 1;
> 	}
> 
> 
> NOTE: to me, check or error message should be reverted, but I know nothing
> about this driver.

Your patch looks to be coherent. However, I suspect that this will break
the driver. There are some functions at the driver for decoding Bayer
format. Without your patch, the if condition will never occur. So, Bayer
decoding will work. 

IMO, the better is to add an #if 0 at the test.

-- 
Cheers,
Mauro

