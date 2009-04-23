Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZDWMOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZDWMOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZDWMO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:14:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40507 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZDWMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:14:27 -0400
Date: Thu, 23 Apr 2009 14:18:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@osdl.org" <torvalds@osdl.org>,
       "akpm@osdl.org" <akpm@osdl.org>
Subject: Re: [PATCH] Eliminate thousands of warnings in WARN_ON with gcc 3.2 build
Message-ID: <20090423121801.GM13896@one.firstfloor.org>
References: <20090422221134.GA1753@basil.nowhere.org> <20090423115846.GA21823@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423115846.GA21823@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 01:58:46PM +0200, Jesper Nilsson wrote:
> >  
> >  #ifdef WANT_WARN_ON_SLOWPATH
> > -void warn_slowpath(const char *file, int line, const char *fmt, ...)
> > +void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
> >  {
> >  	va_list args;
> >  	char function[KSYM_SYMBOL_LEN];
> > @@ -358,7 +358,7 @@
> >  	if (board)
> >  		printk(KERN_WARNING "Hardware name: %s\n", board);
> >  
> > -	if (fmt) {
> > +	if (*fmt) {
> 
> Is this completely safe? If somebody is stupid enough to call
> WARN(condition, NULL); this won't work as it did before.
> OTOH, it would still be useless in debugging...

Noone in tree does according to grep. I would also argue
anyone doing that to be really broken.

> 
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

Thanks.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
