Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYGNO5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYGNO5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbYGNO4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:56:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbYGNO4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:56:49 -0400
Subject: Re: [PATCH] advansys: use request_firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <20080714145033.GD14894@parisc-linux.org>
References: <1215770322.2733.12.camel@jaswinder.satnam>
	 <20080712162921.GZ14894@parisc-linux.org>
	 <1215882548.19076.57.camel@jaswinder.satnam>
	 <20080714145033.GD14894@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 07:56:44 -0700
Message-Id: <1216047404.27455.31.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 08:50 -0600, Matthew Wilcox wrote:
> I'm not quite sure whether my question was answered ...
> 
> When firmware is built in, does
> 1) request_firmware() make a copy of it and then release_firmware free
>    that copy?
> 2) request_firmware() return a pointer to the built-in firmware with
>    release_firmware() being a no-op?
> 3) request_firmware() return a pointer to the built-in firmware with
>    release_firmware() freeing the original?
> 
> Cases 1 and 2 are fine, case 3 is a problem.

Effectively (2).

Actually we do allocate and free the 'struct firmware' but fw->data is
just pointed to the original blob, and then that blob doesn't get freed.

-- 
dwmw2

