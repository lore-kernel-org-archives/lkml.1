Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZJKO1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZJKO1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 10:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZJKO1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 10:27:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbZJKO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 10:27:42 -0400
Date: Sun, 11 Oct 2009 11:26:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
       Andy Walls <awalls@radix.net>
Subject: Re: checkpatch is not detecting bad whitespacing when using macros
 on formulas
Message-ID: <20091011112624.39830ef9@pedra.chehab.org>
In-Reply-To: <4AD1BB06.70309@imap.cc>
References: <20091011071911.54347f2b@pedra.chehab.org>
	<4AD1BB06.70309@imap.cc>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 11 Oct 2009 13:01:26 +0200
Tilman Schmidt <tilman@imap.cc> escreveu:

> Mauro Carvalho Chehab schrieb:
> > While reviewing a patch from Andy Walls, I noticed that checkpatch v 0.29
> > didn't get any errors when bad whitespacing is used on some formulas:
> > 
> > $ checkpatch.pl cx23888-ir-part2_2.patch
> > total: 0 errors, 0 warnings, 1237 lines checked
> > 
> > cx23888-ir-part2_2.patch has no obvious style problems and is ready for submission.
> > 
> > However, there are several places at the patch like:
> > 
> > +static inline u16 ns_to_clock_divider(unsigned int ns)
> > +{
> > +       return count_to_clock_divider(
> > +                 DIV_ROUND_CLOSEST(CX23888_IR_REFCLK_FREQ/1000000 * ns, 1000));
> > +}
> 
> checkpatch is already complaining too much rather than too little.
> No need to add even more complaints.
> 
> The code you cite above is fine IMHO, but if you don't like it, feel
> free to raise your complaints. You can do so without help from
> checkpatch, too.

Chapter 3.1 of CodingStyle says:

	Use one space around (on each side of) most binary and ternary operators,
	such as any of these:

	        =  +  -  <  >  *  /  %  |  &  ^  <=  >=  ==  !=  ?  :

At the above, it should have an space before and after the first division
operator. So, we should or fix checkpatch.pl or remove the above rule from
CodingStyle.

Note that the patch has other similar troubles, like:

+       if (d > RXCLK_RCD+1)
+                                CX23888_IR_REFCLK_FREQ/1000000);
+       if (rem >= CX23888_IR_REFCLK_FREQ/1000000/2)
+       clocks = CX23888_IR_REFCLK_FREQ/1000000 * (u64) ns; /* millicycles    */
+       return DIV_ROUND_CLOSEST((n+1) * 100, 16);



Cheers,
Mauro
