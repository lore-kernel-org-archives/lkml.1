Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbXEQUxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbXEQUxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbXEQUxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:53:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58415 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbXEQUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:53:43 -0400
Date: Thu, 17 May 2007 21:53:39 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dedekind@infradead.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517205339.GS4095@ftp.linux.org.uk>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron> <20070517102931.6bbbad1a.akpm@linux-foundation.org> <20070517204234.GR4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517204234.GR4095@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ahem...  So what does
> 	x |= y;
> turns into with that approach?

BTW, you can simply typedef __be16 ubi16_t; etc. and define conversion
functions as cpu_to_ubi16(x) being (__force ubi16_t)cpu_to_be16(x), etc.

sparse will do all checks just fine, you still have bitwise operations
(might or might be not relevant in your case) and for gcc it simply
becomes __be16, etc - i.e. an integer type.
