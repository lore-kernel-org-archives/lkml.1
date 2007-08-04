Return-Path: <linux-kernel-owner+w=401wt.eu-S1766004AbXHDWtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766004AbXHDWtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764969AbXHDWtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:49:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:2157 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764963AbXHDWtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WAvGLBDetaw9+eiZmNx4J3E+gQpPYBw0XfhbBfspmuGPrqAxC6mrBvGz2T9WC8MFVL9m55f7q/VSWescIAQ2FmKlPDHp46AePF9+cPk8ufiSwhf67+rH9QF/XRwd4tK3FdnHJwKARN3jQD1hOWZDVuVmxpbJYr05aQPJp1JqrZc=
Date: Sun, 5 Aug 2007 02:49:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
Message-ID: <20070804224902.GA9047@martell.zuzino.mipt.ru>
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in> <20070801053509.GA5905@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in> <Pine.LNX.4.64.0708030958450.495@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.999.0708031357530.25703@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708031357530.25703@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 02:29:06PM +0530, Satyam Sharma wrote:
> On Fri, 3 Aug 2007, Jan Engelhardt wrote:
> 
> > 
> > On Aug 2 2007 05:16, Satyam Sharma wrote:
> > >
> > >BSD's strtonum(3) is a detestful, horrible shame.
> > >
> > >The strtol_check_range() I implemented here does _all_ that strtonum()
> > >does, plus is generic w.r.t. base, and minus the tasteless "errstr"
> > >argument.
> > >
> > >Tell me, how does that "errstr" ever make sense? We _anyway_ return
> > >errors (-EINVAL or -ERANGE) if any of those cases show up.
> > 
> > errstr (well, at least for strtol) are useful to find the first character that
> > does not make up a number (and then do whatever the user wants to, including,
> > continuing to parse). For example "chown 0:1337", strtol on "0:1337" should
> > give errstr=pointer to the ":", then check for it being a ':', then you know
> > the next char is the GID. :)
> 
> We were actually discussing the "errstr" that's the fourth argument of
> BSD's strtonum(3) which has quite radically different semantics [1]
> from the "endptr" argument of strtol(3).

Glad you've noticed.

> Anyway, I originally
> misunderstood the interface / the correct way to be using that function
> as I later mentioned in the other mail -- also see the answer to point
> #3 in [2]. Porting it over to here does sound like a good idea.

> [1] http://www.freebsd.org/cgi/man.cgi?query=strtonum&apropos=0&sektion=3&manpath=FreeBSD+7-current&format=html
> [2] http://lists.freebsd.org/pipermail/freebsd-current/2005-April/048744.html

Actually, strtonum() rejects "42\n" which means we can't massively use
it. :-(

