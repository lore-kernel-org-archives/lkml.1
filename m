Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYBJTHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYBJTHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYBJTHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:07:12 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:37113 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYBJTHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=a5fD1jTvwpeSOpwy+5TpcvUyyrv5o0bBTLDViJKrbp/3p365NxNT4WhEKXYVhDa+WPWqvARoebUOyhpmw5B6Q8o031ssJzhAlpD2uLmsCFo/NsVIgar3nzTTyxqVDjwskAweQ+pPVL6fLaUyP4nBl767kY1KZ3DhQ+Qv+YCGieA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [3/6] kgdb: core
Date: Sun, 10 Feb 2008 20:20:45 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
References: <20080210071331.GC3851@elte.hu> <20080210124629.GA12200@joi> <20080210164327.GA7088@elte.hu>
In-Reply-To: <20080210164327.GA7088@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802102020.45829.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, Ingo Molnar wrote:
> 
> * Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > > +		if (CACHE_FLUSH_IS_SAFE) {
> > > +			if (current->mm && addr < TASK_SIZE) {
> > > +				flush_cache_range(current->mm->mmap_cache,
> > > +						addr, addr + BREAK_INSTR_SIZE);
> > > +			} else {
> > > +				flush_icache_range(addr, addr +
> > > +						BREAK_INSTR_SIZE);
> > > +			}
> > > +		}
> > unneeded braces (here and in many other places)
> 
> this is a small detail, but you are wrong. These braces around 
> multi-line statements are unneded _for the compiler_, but are very much 
> wanted by humans. You'll see akpm, me and others reject/fix patches on a 
> routine basis that make this cleanliness mistake. Please watch out for 
> this when writing patches ;-)
> 
> > if ()
> > else if ()
> > else
> > 
> > will look better
> 
> nope. I consciously avoid that construct because it's dangerous: it can 
> quite easily result in the wrong logic. Having _more_ braces than needed 
> by the compiler is a style error in only a single, special case.

however it can be still made to:

if () {
	if ()
	else
}

[ not fixed in v6 ]
