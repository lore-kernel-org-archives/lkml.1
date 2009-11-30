Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZK3Jlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZK3Jlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZK3Jly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:41:54 -0500
Received: from smtp.nokia.com ([192.100.122.233]:61083 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZK3Jlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:41:53 -0500
Subject: Re: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses
 and panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20091130093541.GA14254@logfs.org>
References: <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	 <20091012110954.67d7d8d8.akpm@linux-foundation.org>
	 <20091012182346.GH17138@elte.hu>
	 <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	 <20091013151751.59e217a7@marrow.netinsight.se>
	 <20091013152235.188059d2@marrow.netinsight.se>
	 <20091126093657.GA25430@logfs.org> <1259566071.7518.48.camel@localhost>
	 <20091130074603.GA30911@logfs.org> <1259571118.7518.56.camel@localhost>
	 <20091130093541.GA14254@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 11:40:55 +0200
Message-Id: <1259574055.7518.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Nov 2009 09:41:01.0055 (UTC) FILETIME=[3A04D8F0:01CA71A1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 10:35 +0100, Jörn Engel wrote:
> On Mon, 30 November 2009 10:51:58 +0200, Artem Bityutskiy wrote:
> > 
> > How about this patch on top of the existing one (untested):
> > 
> > +	/*
> > +	 * Have we ever rotated around the circular buffer? If we never did,
> > +	 * we have to have zeroes at the end.
> > +	 */
> > +	if (log_buf[end]) {
> > +		s1 = log_buf + end;
> > +		l1 = log_buf_len - end;
> > +	} else {
> > +		s1 = "";
> > +		l1 = 0;
> 
> So now you are assuming that a) the buffer is initially zeroed and b)
> noone ever writes NUL to it.  Is that correct?

a) seems to be true because the buffer is either a static array or a
bootmem alloc, which seems to memzero the buffers it returns, at least
AFAICS. But I did not test this.

vs b). well, the printk ring buffer should contain ASCII, so I assumed
binary zeroes should not be possible there.

> I'm not sure whether those assumptions are valid.  If they are, then
> this will obviously work.  Otherwise we can just always assume the
> wrapped case.

Of course someone who has more knowlege about the printk buffer should
comment on this.

The other alternative I was thinking about was to introduce a boolean
flag, and set it to one as soon as 'lon_end' becomes larger than
'log_buf_len'.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

