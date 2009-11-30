Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZK3Jfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZK3Jfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZK3Jfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:35:50 -0500
Received: from lazybastard.de ([212.112.238.170]:46468 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbZK3Jft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:35:49 -0500
Date: Mon, 30 Nov 2009 10:35:41 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses and panics
Message-ID: <20091130093541.GA14254@logfs.org>
References: <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain> <20091012110954.67d7d8d8.akpm@linux-foundation.org> <20091012182346.GH17138@elte.hu> <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain> <20091013151751.59e217a7@marrow.netinsight.se> <20091013152235.188059d2@marrow.netinsight.se> <20091126093657.GA25430@logfs.org> <1259566071.7518.48.camel@localhost> <20091130074603.GA30911@logfs.org> <1259571118.7518.56.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259571118.7518.56.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 November 2009 10:51:58 +0200, Artem Bityutskiy wrote:
> 
> How about this patch on top of the existing one (untested):
> 
> +	/*
> +	 * Have we ever rotated around the circular buffer? If we never did,
> +	 * we have to have zeroes at the end.
> +	 */
> +	if (log_buf[end]) {
> +		s1 = log_buf + end;
> +		l1 = log_buf_len - end;
> +	} else {
> +		s1 = "";
> +		l1 = 0;

So now you are assuming that a) the buffer is initially zeroed and b)
noone ever writes NUL to it.  Is that correct?

I'm not sure whether those assumptions are valid.  If they are, then
this will obviously work.  Otherwise we can just always assume the
wrapped case.

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
