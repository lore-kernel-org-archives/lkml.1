Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZF0HqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZF0HqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 03:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZF0HqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 03:46:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:57571 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZF0HqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 03:46:03 -0400
Subject: Re: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
From: David Woodhouse <dwmw2@infradead.org>
To: vimal singh <vimalsingh@ti.com>
Cc: "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "david-b@pacbell.net" <david-b@pacbell.net>
In-Reply-To: <63536.192.168.10.89.1246081026.squirrel@dbdmail.itg.ti.com>
References: <53729.192.168.10.89.1246035472.squirrel@dbdmail.itg.ti.com>
	 <57946.192.168.10.89.1246035774.squirrel@dbdmail.itg.ti.com>
	 <63536.192.168.10.89.1246081026.squirrel@dbdmail.itg.ti.com>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 08:45:59 +0100
Message-Id: <1246088759.663.106.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 11:07 +0530, vimal singh wrote:
> > The 'status' you return in the case that you _have_ gone through the
> > loop is still wrong though, isn't it?
> Yes, I have corrected that in below patch. Its my bad, I did not fix it
> previously.
> 
> Signed-off-by: Vimal Singh <vimalsingh at ti.com>
> Signed-off-by: Ming Lei <tom.leiming at gmail.com>

Er, did he? And please put proper email addresses in. If you can't find
an @ sign on your keyboard, cut and paste it from elsewhere.

> @@ -558,6 +560,7 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip
>  		status = __raw_readb(this->IO_ADDR_R);
> -		if (!(status & 0x40))
> +		if (status & NAND_STATUS_READY)
>  			break;

Hm... now you're polling the PASS/FAIL bit in the status, not the
READY/BUSY bit. I suspect that's not going to work too well...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

