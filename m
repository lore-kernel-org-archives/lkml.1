Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbXHCIqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbXHCIqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 04:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXHCIqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 04:46:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbXHCIql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 04:46:41 -0400
Date: Fri, 3 Aug 2007 14:29:06 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
In-Reply-To: <Pine.LNX.4.64.0708030958450.495@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.999.0708031357530.25703@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
 <20070801053509.GA5905@martell.zuzino.mipt.ru>
 <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
 <Pine.LNX.4.64.0708030958450.495@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,


On Fri, 3 Aug 2007, Jan Engelhardt wrote:

> 
> On Aug 2 2007 05:16, Satyam Sharma wrote:
> >
> >BSD's strtonum(3) is a detestful, horrible shame.
> >
> >The strtol_check_range() I implemented here does _all_ that strtonum()
> >does, plus is generic w.r.t. base, and minus the tasteless "errstr"
> >argument.
> >
> >Tell me, how does that "errstr" ever make sense? We _anyway_ return
> >errors (-EINVAL or -ERANGE) if any of those cases show up.
> 
> errstr (well, at least for strtol) are useful to find the first character that
> does not make up a number (and then do whatever the user wants to, including,
> continuing to parse). For example "chown 0:1337", strtol on "0:1337" should
> give errstr=pointer to the ":", then check for it being a ':', then you know
> the next char is the GID. :)

We were actually discussing the "errstr" that's the fourth argument of
BSD's strtonum(3) which has quite radically different semantics [1]
from the "endptr" argument of strtol(3). Anyway, I originally
misunderstood the interface / the correct way to be using that function
as I later mentioned in the other mail -- also see the answer to point
#3 in [2]. Porting it over to here does sound like a good idea.

I'm off on vacation with little or intermittent (possibly none) access
to email for the next 10 days, so please feel free to beat me to it :-)


Satyam

[1] http://www.freebsd.org/cgi/man.cgi?query=strtonum&apropos=0&sektion=3&manpath=FreeBSD+7-current&format=html
[2] http://lists.freebsd.org/pipermail/freebsd-current/2005-April/048744.html
