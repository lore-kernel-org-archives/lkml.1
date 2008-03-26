Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbYCZLKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbYCZLKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbYCZLKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:10:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbYCZLKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:10:36 -0400
Date: Wed, 26 Mar 2008 12:10:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J?rn Engel <joern@logfs.org>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch] bkl2mtd: cleanup
Message-ID: <20080326111021.GF17176@elte.hu>
References: <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326101452.GA17176@elte.hu> <20080326104821.GS10722@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326104821.GS10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> > -static int _block2mtd_write(struct block2mtd_dev *dev, const u_char *buf,
> > -		loff_t to, size_t len, size_t *retlen)
> > +static int
> > +_block2mtd_write(struct block2mtd_dev *dev, const u_char *buf, loff_t to,
> > +		 size_t len, size_t *retlen)
> 
> That's actually worse...  BTW, single-underscore-... for identifiers?  
> Odd.

(yep, that's odd.)

> > -static int block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
> > +static int
> > +block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
> >  		size_t *retlen, const u_char *buf)
> 
> Again, why split it that way?

these are really nuances, so unless you are interested in such nuances 
nowhere found in CodingStyle, stop reading here :-)

i personally try to minimize the number and complexity of function 
prototype patterns, while still trying to keep the linecount low. So if 
a function prototype wants to be multi-line, it's not a "simple one-line 
function prototype" anymore, so i use the same template for everything:

 type
 function_name(vars ...
               more vars ...)
 {

[ having the 'type' separately makes it easy to judge the return type of 
  a function (especially with syntax highlighting active). Aligned 
  variables are an efficient extension of the 'line' concept that does 
  not mix the function_name with the variables. ]

incidentally, a natural simplified variant of that is the following:

 type
 function_name(vars...)
 {

which tends to stay cleanly 2-line and looks tidier and shorter than 
the:

 type function_name(vars...
                    more vars ...)
 {

form. The preferred form is of course:

 type function_name(vars...)

	Ingo
