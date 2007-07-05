Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbXGERJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbXGERJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbXGERJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:09:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38221 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbXGERJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:09:19 -0400
Date: Thu, 5 Jul 2007 18:09:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
Message-ID: <20070705170918.GO21478@ftp.linux.org.uk>
References: <20070705093528.GK21478@ftp.linux.org.uk> <alpine.LFD.0.98.0707050930330.9434@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0707050930330.9434@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 09:41:55AM -0700, Linus Torvalds wrote:
> IOW, as far as I can tell, there's really no reason to add a 
> "__qualifier__" handler, because it's not going to help us. Anything we 
> can do with __qualifier__, we can already do with our __attribute__ 
> parsing: what you suggest would involve having a new place for parsing 
> __attributes__, and making the *current* qualifier-like attribute parsing 
> trigger on "__qualifier__" instead.
> 
> So what I'd suggest is to just have *both* cases trigger on __attribute__, 
> but in the qualifier case we'd use NS_QUALIFIER to look up the attribute 
> function, and in the non-qualifier case we'd use NS_ATTRIBUTE (right now 
> we always use NS_KEYWORD, and that's probably bogus: we should put the 
> attribute names in another namespace _anyway_).

But that's the problem - we have places where *both* qualifiers and
attributes are allowed and they apply to different parts of declaration.

Note that we mishandle __attribute__((mode())) right now in a way that
makes no sense at all.  E.g. if it happens in the end of declaration,
we still apply it to the root type.  gcc applies it to the entire
declaration in that case, and that certainly makes much more sense.

So I'm afraid that we need to change __attribute__ parsing anyway...
