Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbXEVOCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbXEVOCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbXEVOCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:02:40 -0400
Received: from [216.16.235.2] ([216.16.235.2]:50504 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbXEVOCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:02:39 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 22 May 2007 10:01:41 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <alpine.DEB.0.99.0705220950160.3308@sigma.j-a-k-j.com>
Message-ID: <Pine.LNX.4.64.0705220959310.14408@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
 <alpine.DEB.0.99.0705220950160.3308@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, John Anthony Kazos Jr. wrote:

> >   given that:
> >
> > $ grep -r "define.*NORET_TYPE" *
> > include/linux/ext4_fs.h:# define NORET_TYPE    /**/
> > include/linux/linkage.h:#define NORET_TYPE    /**/
> > include/linux/ext3_fs.h:# define NORET_TYPE    /**/
> > $
> >
> > is there any obvious value to the 30 or so uses of that macro
> > sprinkled throughout the tree?
>
> Since it evaluates to absolutely empty code during pre-processing,
> there is no obvious value. The question is whether there is some odd
> hackish non-obvious value, I'd expect. (I'd also expect that to be
> another "no".)
>
> If something that evaluates to nothingness ("There was nothing
> left...not even a hole!") actually does anything, then somebody in
> the standards-compilers-users pipeline needs to be violently beaten
> for stupidity.


actually, one of the folks on the KJ list found this:

  http://www.ussg.iu.edu/hypermail/linux/kernel/9605/1957.html

which speaks thusly:

...
-#if __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 5)
-# define NORET_TYPE __volatile__
-# define ATTRIB_NORET /**/
-# define NORET_AND /**/
-#else
# define NORET_TYPE /**/
# define ATTRIB_NORET __attribute__((noreturn))
# define NORET_AND noreturn,
-#endif
...

  so it looks like a thoroughly obsolete macro which can be tossed.
i'll make the patch and test it.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
