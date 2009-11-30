Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZK3H27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZK3H27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZK3H26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:28:58 -0500
Received: from smtp.nokia.com ([192.100.122.230]:35274 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZK3H25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:28:57 -0500
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
In-Reply-To: <20091126093657.GA25430@logfs.org>
References: <20091012122023.GA19365@elte.hu>
	 <20091012150650.51a4b4dc@marrow.netinsight.se>
	 <20091012131528.GC25464@elte.hu>
	 <20091012153937.0dcd73e5@marrow.netinsight.se>
	 <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	 <20091012110954.67d7d8d8.akpm@linux-foundation.org>
	 <20091012182346.GH17138@elte.hu>
	 <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	 <20091013151751.59e217a7@marrow.netinsight.se>
	 <20091013152235.188059d2@marrow.netinsight.se>
	 <20091126093657.GA25430@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 09:27:51 +0200
Message-Id: <1259566071.7518.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Nov 2009 07:27:58.0347 (UTC) FILETIME=[A3F445B0:01CA718E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 10:36 +0100, Jörn Engel wrote:
> Just stumbled across this patch.
> 
> On Tue, 13 October 2009 15:22:35 +0200, Simon Kagstrom wrote:
> > +void dump_kmsg(int panic)
> > +{
> > +	unsigned long len = ACCESS_ONCE(log_end);
> > +	struct dump_device *dump;
> > +	const char *s1, *s2;
> > +	unsigned long l1, l2;
> > +
> > +	s1 = "";
> > +	l1 = 0;
> > +	s2 = log_buf;
> > +	l2 = len;
> > +
> > +	/* Have we rotated around the circular buffer? */
> > +	if (len > log_buf_len) {
> 
> I believe this bit is wrong.  log_end is an unsigned int, so it can
> wrap relatively quickly.  If log_end just wrapped to 0 and dump_kmsg is
> called, the amount of printk buffer stored appears to be 0 as well.

To me it looks like 'log_end' is not supposed to wrap. What makes you
think it can? In which cases it can?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

