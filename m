Return-Path: <linux-kernel-owner+w=401wt.eu-S1030286AbXAaRGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030286AbXAaRGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030289AbXAaRGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:06:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58456 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030286AbXAaRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:06:54 -0500
Subject: Re: [PATCH] ubi:  int versus size_t printk warnings
From: David Woodhouse <dwmw2@infradead.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, dedekind@infradead.org
In-Reply-To: <20070131170257.79ca59b7@localhost.localdomain>
References: <20070131170257.79ca59b7@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 17:06:51 +0000
Message-Id: <1170263211.29759.334.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 17:02 +0000, Alan wrote:
> Another mtd driver, another set of 32bit assumptions. Please compile mtd
> stuff on 64bit now and then, or if stuff is for 32bit only systems then
> add the right CONFIG rules.

We've been building MTD stuff on 64-bit machines since about 1999, when
I first put a DiskOnChip in an ISA eval board in an Alpha. 

The _problematic_ 32-bit assumption in MTD code is the fact that device
size is limited to 4GiB. That used to be "insanely large" in the context
of flash chips, but it's not so any more. We'll have to deal with that
soon enough.

> +               ubi_err("error %d while reading %Zd bytes from PEB %d:%d, "

Nak. %Zd is a gratuitous GNUism. In C, we use %zd.

Artem (dedekind) is the correct person to deal with UBI stuff. I've
added him to Cc.

-- 
dwmw2

