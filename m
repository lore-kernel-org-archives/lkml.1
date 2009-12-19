Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbZLSOeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbZLSOeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 09:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZLSOeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 09:34:36 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53039 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZLSOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 09:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hIRP5RgobA37Iwud0H/U/AOR/OR+kIyHNOneqMZkXso7rS4qCguBp8xvpEmq4kuPwj
         BCh5BnfUkvBCE5/acquEiuIaB4o3aAfYCOadvd8eWthW1+w7t1oxleJEzm1f8jevmUWJ
         8hJd6ZC3Jdnf5BgptnBk+RBaMXvJm9Ipi3WMk=
Date: Sat, 19 Dec 2009 15:34:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Prevent from BITS_PER_LONG redefinition
Message-ID: <20091219143425.GA5003@nowhere>
References: <1261173920-11320-1-git-send-regression-fweisbec@gmail.com> <1261214767.20899.697.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261214767.20899.697.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 10:26:07AM +0100, Peter Zijlstra wrote:
> On Fri, 2009-12-18 at 23:05 +0100, Frederic Weisbecker wrote:
> > +#ifndef BITS_PER_LONG
> >  /* CHECKME: Not sure both always match */
> >  #define BITS_PER_LONG  __WORDSIZE
> > +#endif 
> 
> Why use __WORDSIZE if you're not sure?
> 
> (8*sizeof(long)) is simple and unambiguous.


Yeah but we need it from the CPP level.
We include such code located in kernel headers:

static __always_inline unsigned long __fls(unsigned long word)
{
	int num = BITS_PER_LONG - 1;

#if BITS_PER_LONG == 64
	if (!(word & (~0ul << 32))) {
		num -= 32;
		word <<= 32;
	}
#endif
	if (!(word & (~0ul << (BITS_PER_LONG-16)))) {
		num -= 16;
		word <<= 16;
	}


And sizeof() is not defined :)

