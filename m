Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbXGTUyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbXGTUyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759268AbXGTUyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:54:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57209 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbXGTUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:54:19 -0400
Date: Fri, 20 Jul 2007 14:54:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Simon Arlott <simon@fire.lp0.eu>, Denis Cheng <crquan@gmail.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
Message-ID: <20070720205418.GK14791@parisc-linux.org>
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk> <20070720170743.GF14791@parisc-linux.org> <E1IBzQw-0000Im-55@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IBzQw-0000Im-55@flower>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:50:42PM +0200, Oleg Verych wrote:
> > Of course, we can't add this flag to Lindent until it's widely
> > circulating amongst the distributions.  Perhaps we can add this to
> > Lindent in the meantime:
> >
> > sed -i -e 's/^\t*      \(\w*:\)/ \1/' "$@"
> >
> > which will replace the leading tabs and spaces with one space.
> > It should leave case labels unmolested, as they should be indented with
> > tabs, not 6 spaces.
> >
> > Any regexp ninjas want to have a go at something better?
> 
> I'm the one. Trying to write portable, optimized and easy to
> understand scripts [0].
> 
> Please, describe more what must be done, and i will do it. Case labels
> are handled very strangely in you example.

OK.  indent will indent labels to a column number that's a multiple of
8, plus 6.  So it may start in column 6, 14, 20, 28, etc.  I'm not quite
sure what the definition of a label is; I had it as \w*: up there, but I
don't know if that would match the _.  The point is to *not* handle case
labels, only goto labels.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
