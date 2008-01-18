Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbYARJsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbYARJsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYARJs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:48:28 -0500
Received: from unthought.net ([212.97.129.88]:60593 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYARJs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:48:27 -0500
Date: Fri, 18 Jan 2008 10:48:26 +0100
From: Jakob Oestergaard <jakob@unthought.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080118094826.GN25527@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Schwartz <davids@webmaster.com>,
	Johannes Weiner <hannes@saeurebad.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	clameter@sgi.com, penberg@cs.helsinki.fi
References: <MDEHLPKNGKAHNMBLJOLKIEGIJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171316390.14959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801171316390.14959@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 01:25:39PM -0800, Linus Torvalds wrote:
...
> Why do you make that mistake, when it is PROVABLY NOT TRUE!
> 
> Try this trivial program:
> 
> 	int main(int argc, char **argv)
> 	{
> 	        int i;
> 	        const int *c;
> 	
> 	        i = 5;
> 	        c = &i;
> 	        i = 10;
> 	        return *c;
> 	}
> 
> and realize that according to the C rules, if it returns anything but 10, 
> the compiler is *buggy*.

That's not how this works (as we obviously agree).

Please consider a rewrite of your example, demonstrating the usefulness and
proper application of const pointers:

extern foo(const int *);

int main(int argc, char **argv)
{
 int i;

 i = 5;
 foo(&i);
 return i;
}

Now, if the program returns anything else than 5, it means someone cast away
const, which is generally considered a bad idea in most other software
projects, for this very reason.

*That* is the purpose of const pointers.

Besides, for most debugging-enabled free() implementations, free() does indeed
touch the memory pointed to by its argument, which makes giving it a const
pointer completely bogus except for a single potential optimized special-case
where it might actually not touch the memory.

-- 

 / jakob

