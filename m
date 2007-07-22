Return-Path: <linux-kernel-owner+w=401wt.eu-S1764881AbXGVUrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764881AbXGVUrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763003AbXGVUrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:47:06 -0400
Received: from lazybastard.de ([212.112.238.170]:38448 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763186AbXGVUrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:47:05 -0400
Date: Sun, 22 Jul 2007 22:43:25 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: drivers/mtd/devices/doc2000.c - address of 'eccbuf' will always evaluate as 'true' , warnings
Message-ID: <20070722204325.GB11479@lazybastard.org>
References: <46A349E6.3030207@googlemail.com> <20070722193449.GA11479@lazybastard.org> <46A3BE29.50501@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46A3BE29.50501@googlemail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 July 2007 22:29:29 +0200, Gabriel C wrote:
> 
> @@ -896,25 +896,6 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
>  		/* Let the caller know we completed it */
>  		*retlen += len;
>  
> -		if (eccbuf) {
> -			unsigned char x[8];
> -			size_t dummy;
> -			int ret;
> -
> -			/* Write the ECC data to flash */
> -			for (di=0; di<6; di++)
> -				x[di] = eccbuf[di];
> -
> -			x[6]=0x55;
> -			x[7]=0x55;
> -
> -			ret = doc_write_oob_nolock(mtd, to, 8, &dummy, x);
> -			if (ret) {
> -				mutex_unlock(&this->lock);
> -				return ret;
> -			}
> -		}
> -
>  		to += len;
>  		left -= len;
>  		buf += len;

You should remove the condition, but not the conditional code.

Jörn

-- 
A quarrel is quickly settled when deserted by one party; there is
no battle unless there be two.
-- Seneca
